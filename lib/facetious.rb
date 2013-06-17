# -*- encoding: utf-8 -*-
require 'active_record'

module Facetious #:nodoc:
  Facet = Struct.new(:name, :field_name, :title, :data_type, :where) do
    ValueConverter = {
      string:
        proc {|value| "'" + value.gsub(/'/, "''") + "'" },
      integer:
        proc {|value| Integer(value).to_s },
      date:
        proc {|value|
          raise "REVISIT: Don't use DATE VALUE before implementing it"
          value
        },
      integers:
        proc {|value|
          '(' + (value-['']).map{|i| Integer(i).to_s}.join(',') + ')'
        },
      strings:
        proc {|value|
          '(' + (value-['']).map{|str| sql_value(:string, str)}.join(',') + ')'
        }
    }

    def sql_value data_type, value
      conversion_proc = ValueConverter[data_type]
      raise "facet data type #{data_type} is not recognised" unless conversion_proc
      conversion_proc.call(value)
    end

    def condition_for value
      name = field_name.to_s
      # puts "condition_for facet #{name}, value #{value.inspect}"
      conditions =
	case value
	when /\A\s*-\s*\Z/
	  if where =~ /\s*\(?\s*EXISTS\b/i
	    nil # No condition will be used, rather the EXISTS will be negated.
	  else
	    '('+name+' IS NULL OR '+name+" = '')"
	  end
	when /\A\s*\*\s*\Z/
	  "#{name} != ''"   # Which also means IS NOT NULL, incidentally
	when /,/
	  '('+
	  value.split(/,/).map(&:strip).map do |alternate|
	    condition_for alternate
	  end.join(' OR ') +
	  ')'
	when /\A(>=?)(.*)/  # Greater than
	  name + " #{$1} " + sql_value(data_type, $2)
	when /\A(<=?)(.*)/  # Less than
	  name + " #{$1} " + sql_value(data_type, $2)
	when /\A~(.*)/    # Near this value
	  # name + ...
	when /\A(.*)\.\.(.*)\z/ # Between
	  name + " >= " + sql_value(data_type, $1) + " AND " +
	  name + " <= " + sql_value(data_type, $2)
	when /%/
	  name + " LIKE " + sql_value(data_type, value)
	when Array
	  '(' + value.map{|v| condition_for v }*' OR ' + ')'
	when Range
	  name + " >= " + sql_value(data_type, value.begin.to_s) + " AND " +
	  name + " <= " + sql_value(data_type, value.end.to_s)
	else      # Equals
	  if [:integers, :strings].include?(data_type)
	    name + " IN " + sql_value(data_type, value.to_s)
	  else
	    name + " = " + sql_value(data_type, value.to_s)
	  end
	end

      if sql = where
	if sql.include?('?')
	  if conditions
	    sql.gsub(/\?/, "  AND "+conditions)
	  else  # Make an EXISTS clause into NOT EXISTS (see above)
	    'NOT '+sql.gsub(/\?/, '')
	  end
	else
	  if sql.match /{{.*}}/
	    name + sql.gsub(/{{.*}}/, sql_value(data_type, value))
	  else
	    sql + "WHERE\t"+conditions
	  end
	end
      else
	conditions
      end
    end
  end

  # These methods are made available on all ActiveRecord classes:
  module BaseClassMethods
    def facet *args
      respond_to?(:facets) or extend FacetedClassMethods

      facet_name = args.first.is_a?(Hash) ? args[-1][:name] : args.shift
      unless facet_name
	raise "Usage: facet :field_name, :title => 'Field Name', :data_type => :string (etc), :where => 'SQL'"
      end

      field_name = (args.first.is_a?(Hash) ? args[-1][:field_name] : args.shift) || facet_name
      title = (args.first.is_a?(Hash) ? args[-1][:title] : args.shift) || facet_name
      data_type = (args.first.is_a?(Hash) ? args[-1][:data_type] : args.shift) || :string
      where = args.first.is_a?(Hash) ? args[-1][:where] : args.shift
      f = self.facets[facet_name] = Facet.new(facet_name, field_name, title, data_type, where)
    end
  end

  # These methods are made available on faceted ActiveRecord classes:
  module FacetedClassMethods
    def where_clause_for_facets facet_values_hash
      facet_values_hash.map do |facet_name, value|
	facet = facets[facet_name.to_sym] or raise "#{self.name} has no search facet #{facet_name}"
	facet.condition_for value
      end*" AND "
    end

    def find_by_facets facet_values_hash
      self.class.where(where_clause_for_facets facet_values_hash)
    end

  private
    # def some_faceted_class_private_method; end

    def self.extended other
      other.instance_exec do
        include Facetious       # Add the instance methods
        self.class_attribute :facets
        self.facets ||= {}
      end
    end
  end

  # These methods will be publicly visible on faceted ActiveRecord instances:
  # def some_faceted_instance; end
end

class ActiveRecord::Base
  extend Facetious::BaseClassMethods
end

if $0 == __FILE__
  class Foo < ActiveRecord::Base  #:nodoc:
    facet :fred
    facet :fly, :data_type => :integer
    facet :nerk, :field_name => 'other_table.nerk', :where => "EXISTS(SELECT * FROM other_table WHERE foos.fk = other_table.id ?)"
  end

  puts Foo.where_clause_for_facets :fred => [2069, 3000..3999], :fly => 100
  puts Foo.where_clause_for_facets :fred => "2069, 3000..3999", :fly => ">=100"
  puts Foo.where_clause_for_facets :fly => ">=100", :nerk => '100..200'
end
