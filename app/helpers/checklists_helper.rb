module ChecklistsHelper
	def format_list_for_display list
		# clip the first line, which is the title, and show the next four lines in preview
		return simple_format convert_into_list list.lines.to_a[1..4].join
	end
	
	# take the user entered checklist and make it a UL
	def convert_into_list list
		return list
	end
end