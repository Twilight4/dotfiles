-- import comment plugin safely
local setup, comment = pcall(require, 'comment')
if not setup then
  return
end

-- enable comment
comment.setup()
