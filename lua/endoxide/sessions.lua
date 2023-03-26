local status_ok, persisted = pcall(require, "persisted")
if not status_ok then
  print("Couldn't load session manager")
  return
end

persisted.setup()
