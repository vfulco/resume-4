def wget(url, file=nil)
  `wget --no-check-certificate #{"-O #{file}" if file } #{url}`
end