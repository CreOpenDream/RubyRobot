$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'webrick'
require 'bot'

class BotServlet<WEBrick::HTTPServlet::AbstractServlet
  @@html =%q{
    <html>
      <body>
        <form method="post" action="http://212.64.12.155:1235/">
          <h1>Talk To A robot</h1>

            <p>
              <b>your name:</b>
              <input type="text" name="name" size="40"/>
              <input type="submit"/>
            </p>
        </form>
       </body>
     </html>
  }
  def do_GET(request, response)
    response.status = 200
    response.content_type ="text/html"
    response.body = @@html
  end
end
server = WEBrick::HTTPServer.new(:Port =>1234)
$bot = Bot.new(:name =>"Fred", :data_file =>"bot_data")
server.mount "/",BotServlet
trap("INT"){server.shutdown}
server.start