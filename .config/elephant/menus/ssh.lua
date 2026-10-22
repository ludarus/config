-- SSH host menu for Walker/Elephant.
-- Reads Host entries from ~/.ssh/config and opens `kitty ssh <host>`.
Name = "ssh"
NamePretty = "SSH"
Icon = "network-server"
Action = "kitty ssh %VALUE%"
Description = "Connect to an SSH host"
SearchName = true

function GetEntries()
  local entries = {}
  local home = os.getenv("HOME")
  local path = home .. "/.ssh/config"

  local f = io.open(path, "r")
  if not f then
    return entries
  end

  local seen = {}
  for line in f:lines() do
    -- match "Host alias1 alias2 ..." (case-insensitive keyword)
    local rest = line:match("^%s*[Hh][Oo][Ss][Tt]%s+(.+)$")
    if rest then
      for host in rest:gmatch("%S+") do
        -- skip wildcard/negated patterns
        if not host:match("[*?!]") and not seen[host] then
          seen[host] = true
          table.insert(entries, {
            Text = host,
            Subtext = "ssh",
            Value = host,
            Icon = "network-server",
          })
        end
      end
    end
  end
  f:close()

  return entries
end
