def switch-layer [layer: string] {
  { ChangeLayer: { new: $layer } } | to json -r | socat -u - TCP:127.0.0.1:62199 # TODO: make this port configured
}

def is-game [win] {
  let app = $win.app_id?
  let title = $win.title?

  ($app =~ '^steam_app_\d+$') or ($app == "com.mojang.minecraft") or $app == "factorio" or ($title =~ '^TETR\.IO -') or ($title =~ '^Jstris -')
}

niri msg -j event-stream | lines | reduce -f { wins: [], focus: null, game: false } { |line, state|
  let ev = $line | from json

  let state = match $ev {
      { WindowsChanged: { windows: $w } } => {
          $state 
          | upsert wins $w 
          | upsert focus ($w | where is_focused | get -o 0.id)
      }
      { WindowOpenedOrChanged: { window: $w } } => {
          let s = ($state | upsert wins ($state.wins | where id != $w.id | append $w))
          if $w.is_focused? { $s | upsert focus $w.id } else { $s }
      }
      { WindowClosed: { id: $id } } => {
          $state 
          | upsert wins ($state.wins | where id != $id) 
          | upsert focus (if $state.focus == $id { null } else { $state.focus })
      }
      { WindowFocusChanged: { id: $id } } => ($state | upsert focus $id)
      _ => $state
  }

  let win = ($state.wins | where id == $state.focus | get -o 0)
  let game = ($win != null and (is-game $win))

  if $game != $state.game {
      switch-layer (if $game { "game" } else { "base" })
      $state | upsert game $game
  } else {
      $state
  }
}
