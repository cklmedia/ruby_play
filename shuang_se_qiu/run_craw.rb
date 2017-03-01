# encoding: utf-8

require 'mechanize'
require 'active_record'
require 'active_support/all'

require "./config"
require "./shuang_se_qiu"
require "./create_table"
  
  #连接数据库
  ActiveRecord::Base.establish_connection(DATABASE_CONFIG)
  #创建表
  # CreateTable.new.change

  #创建agent对象
  a = Mechanize.new { |agent|
    agent.user_agent_alias = 'Windows Mozilla'
  }

  # 表格查找匹配路径
  xpaths = [
    [:phase, 'td[1]/text()'],
    [:red_1, 'td[2]/p[1]/span[1]/text()'],
    [:red_2, 'td[2]/p[1]/span[2]/text()'],
    [:red_3, 'td[2]/p[1]/span[3]/text()'],
    [:red_4, 'td[2]/p[1]/span[4]/text()'],
    [:red_5, 'td[2]/p[1]/span[5]/text()'],
    [:red_6, 'td[2]/p[1]/span[6]/text()'],
    [:blue, 'td[3]/p[1]/span[1]/text()'],
    [:award, 'td[4]/text()']
  ]


  begin
    (0..31).each do |p|
      puts "--------开始抓取--第#{p}页--"
      # 页码
      try_num1 = p == 0 ? "" : "_"+p.to_s

      # 获取页面
      begin
        page = a.get("http://www.cwl.gov.cn/kjxx/ssq/hmhz/index#{try_num1}.shtml")
      rescue Mechanize::ResponseCodeError
        try_num1 = try_num1 + 1
      end

      # 解析页面获取表格行
      rows = page.css('table.hz tbody tr')
      rows.collect do |row|
        if row.at_xpath(xpaths.first.last).to_s.strip != "期号" && row.at_xpath(xpaths.first.last).to_s.strip != "红球"
          detail = {}
          xpaths.each do |name, xpath|
            detail[name] = row.at_xpath(xpath).to_s.strip.delete("注")
          end
          # 插入数据库
          ShuangSeQiu.build_by_attrs(detail)
        end
      end
    end
    puts "--------结束抓取-----------"
  rescue
    puts "--------抓取异常-----------"
  end
