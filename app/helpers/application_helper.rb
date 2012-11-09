module ApplicationHelper
	def site_title(page_title)
		title = !page_title.empty? ? "notGugle | #{page_title}" : "notGugle"
	end
end
