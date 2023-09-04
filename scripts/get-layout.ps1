
function getLayout {
    param([string] $name)
    $rq = Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Herdubreid/ais.pwsh/main/layouts/${name}.json"
    return $rq.content
  }
  