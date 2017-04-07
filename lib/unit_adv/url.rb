# See: http://ruby-doc.org/stdlib-2.0.0/libdoc/uri/rdoc/URI.html
#

class UnitAdv::Url

  attr_accessor :obj

  def initialize(init_url)
    self.obj = URI.parse(init_url)
  end

  def query_hash
    return CGI.parse obj.query if obj.query.present?
    nil
  end

  def subdomain(n = 0)
    n = -3 if n == "max"
    obj.host.split('.')[0..n].join('.')
  end

  def domain(path = "/")
    URI.join obj.to_s, path
  end

  def method_missing(method_sym)
    obj.send(method_sym)
  end

end
