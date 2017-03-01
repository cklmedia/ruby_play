# encoding: utf-8

require 'active_record'

class ShuangSeQiu	< ActiveRecord::Base

	# 插入数据
	def self.build_by_attrs(attr_hash={})
		attr_hash[:created_at]=Time.now
		attr_hash[:updated_at]=Time.now
    return ShuangSeQiu.create(attr_hash)
  end

end