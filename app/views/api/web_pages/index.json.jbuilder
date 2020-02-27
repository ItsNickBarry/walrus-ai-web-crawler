json.array! @web_pages do |web_page|
  json.extract! web_page, :id, :title, :uri
end
