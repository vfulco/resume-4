def wget(url, file=nil)
  `wget --no-check-certificate #{"-O #{file}" if file } #{url}`
end

module LatexEscape
  def latex_escape
    return self.
      to_s.
      gsub(/&/, /\\&/.source).
      gsub(/(LaTeX)/, '\\\\\1')
  end
  def le
    self.latex_escape
  end
end

class String
  include LatexEscape
end
class Fixnum
  include LatexEscape
end