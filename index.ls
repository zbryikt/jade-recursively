require! <[fs jade path]>

mkdir-recurse = (f) ->
  if fs.exists-sync f => return
  parent = path.dirname(f)
  if !fs.exists-sync parent => mkdir-recurse parent
  fs.mkdir-sync f

jade-recursively = (src,des,config,rel="") ->
  src-full = path.join(src, rel)
  des-full = path.join(des, rel)
  files = fs.readdir-sync src-full .map (f) -> [
      path.join(src-full, f)
      path.join(des-full, f.replace(/\.jade$/, ".html"))
      path.join(rel, f)
  ]
  for file in files =>
    if fs.lstat-sync file.0 .is-directory! => 
      doJade src, des, config, file.2
      continue
    if /\.jade$/.exec file => 
      mkdir-recurse path.dirname file.1
      fs.write-file-sync file.1, jade.renderFile(file.0, config)

# example: jade-recursively \src, \static, {hello: 456}
module.exports = jade-recursively
