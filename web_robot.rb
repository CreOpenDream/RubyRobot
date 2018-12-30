$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'webrick'
require 'bot'
@username = "unnamed";
class BotServlet<WEBrick::HTTPServlet::AbstractServlet
  @@html =%q{
    <html>
      <body>
        <form method="get">
          <h1>Talk To A bot</h1>
            %RESPONSE%
            <p>
              <b>You say:</b>
              <input type="text" name="line" size="40"/>
              <input type="submit"/>
            </p>
        </form>
       </body>
     </html>
  }
  def do_POST(request, response)
    response.status = 200
    response.content_type ="text/html"

    #if the user supplies some text, respond to it
    if request.query['name'] && request.query['name'].length >1
      $username =request.query['name'].chomp
      ##save the chating
    else
      $username ="unnamed"
    end
    response.body = @@html.sub(/\%RESPONSE\%/, "Welcome!"+$username)
  end
  def do_GET(request, response)
    response.status = 200
    response.content_type ="text/html"

    #if the user supplies some text, respond to it
    if request.query['line'] && request.query['line'].length >1
      bot_text = $bot.response_to(request.query['line'].chomp)
      ##save the chating
      handle = File.open($username+".txt","a+")
      handle.puts Time.now.to_s+" "+request.query['line'].chomp.to_s;
      handle.close
    else
      bot_text = $bot.greeting
    end

    #format the text and substitute into the html template
    bot_text = %Q{<p><b>#{$bot.name} say:</b>#{bot_text}</p>}
    response.body = @@html.sub(/\%RESPONSE\%/, bot_text)

  end
end

server = WEBrick::HTTPServer.new(:Port =>1235)
$bot = Bot.new(:name =>"Fred", :data_file =>"bot_data")
server.mount "/",BotServlet
trap("INT"){server.shutdown}
server.start