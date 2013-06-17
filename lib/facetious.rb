# -*- encoding: utf-8 -*-
require 'active_record'

module Facetious #:nodoc:
  # These methods are made available on all ActiveRecord classes:
  module ClassMethods
    def facet *args
      extend ClassPrivate
      include Facetious
    end
  end

  # These methods are made available on faceted ActiveRecord classes:
  module ClassPrivate
    def some_faceted_class_method
    end
  private
    # def some_faceted_class_private_method; end
  end

  # These methods will be publicly visible on faceted instances:
  def some_faceted_instance_method
  end
end
