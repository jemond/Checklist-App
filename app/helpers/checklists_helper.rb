module ChecklistsHelper
	def format_list_to_summary list
		# clip the first line, which is the title, and show the next four lines in preview
		return convert_to_list list.lines.to_a[1..3].join
	end
	
	# take the user entered checklist and make it a UL
	def convert_to_list list
		html = ''
		# loop on line breaks, remove any starting number and then wrap in line breaks
		list.split("\n").each do |item|
			html = html + '<li>' + item.gsub(/[0-9]+[ ]?[\.]?[\-]?/,'') + '</li>'
		end
		return '<ol>' + html + '</ol>'
	end
	
	# wrapper for prettify
	def prettify date
		return time_ago_in_words date
	end
end