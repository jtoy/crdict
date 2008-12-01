require 'osx/cocoa'

class Controller < OSX::NSObject
  attr_writer :results_table_view, :search_field
  
  def awakeFromNib
	@results = []
	@results_table_view.dataSource = self
	@path = OSX::NSBundle.mainBundle.resourcePath.fileSystemRepresentation
=begin	
	@dict ||= File.readlines(@path+"/cedict_ts.u8")[1..-1].collect do |x|
	  r= Result.new
	  data= /(\S+) (\S+) \[(.+)\] (.+)/.match(x)
	  r.chinese =  data[1]
	  r.english =  data[4]
	  r.pinyin = data[3]
	  r.simplified = data[2]
	end
=end
  end

  def dict
	@dict ||= File.readlines @path+"/cedict_ts.u8"
  end
  
  def numberOfRowsInTableView view
    @results.size
  end
    
  def tableView_objectValueForTableColumn_row(view, column, index)
  #def tableView(view, objectValueForTableColumn:column, row:index)
    r = @results[index]
 	r.send column.identifier
  end
  
  def search(sender)
	q = @search_field.stringValue
	#sender.window.Title=title if frame == sender.mainFrame
	puts "query: #{q}"
	matches = q.blank? ? [] : dict.select{|x| x.match /#{q}/}
	@results = []
	sender.window.Title= "#{matches.size} results for #{q}"
	matches.each do |x|
	  r= Result.new
	  data= /(\S+) (\S+) \[(.+)\] (.+)/.match(x)
	  #data = x.split(" ")

	  #data = []
	  puts 'qqq'
	  r.chinese =  data[1]
	  r.english =  data[4]
	  r.pinyin = data[3]
	  r.simplified = data[2]
	  @results << r
	end
	@results_table_view.reloadData
  end
end


class Result
  attr_accessor :chinese, :english,:pinyin,:simplified,:jyutpin
end

class String
  def blank?
    nil? || strip == ""
  end
  
  def chinese?
    !english?
  end
  
  def english?
    match(/\D+/)
  end
  
end