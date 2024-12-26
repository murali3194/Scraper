defmodule Scraper.Fetchurl do

  @url ["https://example.com/",
  "https://www.example.com/#bead",
  "https://www.example.com/?back=boat&bird=blood",
  "http://bed.example.com/",
  "http://www.example.com/",
  "https://www.example.net/aunt",
  "https://example.com/balance.html",
  "http://book.example.com/back?book=bottle",
  "https://example.edu/aunt/bit.html",
  "https://amusement.example.net/boy/alarm",
  "https://www.example.com/?act=air&ants=bedroom#afternoon",
  "https://www.example.com/",
  "https://www.example.net/apparel.html",
  "http://example.com/",
  "http://amusement.example.net/bell.html",
  "https://www.example.com/?approval=army&apparatus=alarm",
  "https://www.example.org/",
  "https://www.example.com/",
  "http://www.example.com/",
  "http://example.edu/arithmetic/branch.php",
  "http://example.net/bear/bait.aspx?apparatus=acoustics&bead=aftermath",
  "https://www.example.com/amusement",
  "https://www.example.net/",
  "http://www.example.com/",
  "http://www.example.com/",
  "http://www.example.net/aftermath/book",
  "http://www.example.net/afternoon.php?boy=authority&bone=believe",
  "http://www.example.com/?behavior=birthday",
  "http://www.example.com/",
  "https://basin.example.com/",
  "https://www.example.com/books/airplane?bone=birds&argument=basin",
  "http://www.example.com/",
  "http://www.example.com/",
  "https://www.example.org/",
  "http://example.com/boat/bee",
  "http://www.example.com/",
  "http://birth.example.com/",
  "http://example.com/",
  "https://www.example.net/bridge/bikes.html",
  "https://example.com/",
  "http://example.net/",
  "http://example.net/balance?books=basket",
  "http://example.com/basketball/board",
  "https://www.example.com/bit/bikes",
  "https://www.example.org/",
  "http://example.com/basket",
  "https://www.example.org/battle/blade.htm",
  "https://example.com/bite",
  "https://www.example.com/",
  "http://www.example.org/birds",
  "https://bead.example.com/boat/birds",
  "http://www.example.com/",
  "https://bedroom.example.com/",
  "http://www.example.com/bee.php?basin=airport&approval=brass#authority",
  "http://example.com/bait/bait",
  "https://example.com/",
  "http://www.example.net/air/ants?back=approval",
  "https://example.com/approval",
  "https://bone.example.com/agreement",
  "https://www.example.org/",
  "https://example.com/",
  "http://www.example.com/",
  "http://www.example.net/border",
  "http://example.com/",
  "http://example.com/boot",
  "https://www.example.org/",
  "https://www.example.com/baseball.php",
  "http://www.example.com/advertisement.aspx#bait",
  "http://example.com/account.html",
  "http://www.example.com/base/agreement",
  "https://www.example.com/aunt",
  "http://www.example.com/?bath=bone",
  "http://blood.example.com/?aftermath=apparel&achiever=angle",
  "https://www.example.com/arm/bone.aspx",
  "http://www.example.com/bag?alarm=animal",
  "https://www.example.com/angle",
  "http://example.net/",
  "http://www.example.org/",
  "https://books.example.com/?addition=arch&bat=branch",
  "http://www.example.net/",
  "http://bridge.example.com/actor/bird",
  "https://www.example.com/badge.aspx",
  "http://www.example.com/brake/baby.htm",
  "http://www.example.com/?anger=anger&bait=battle",
  "https://example.com/",
  "https://www.example.com/",
  "http://example.com/",
  "https://example.com/#army",
  "https://achiever.example.com/achiever",
  "https://www.example.org/",
  "https://example.com/",
  "https://example.com/?back=aunt",
  "https://www.example.com/actor/ball.aspx?baseball=argument",
  "http://www.example.com/afternoon.html?bikes=acoustics",
  "https://www.example.com/?bomb=actor&bikes=baseball",
  "http://www.example.com/babies.html",
  "http://www.example.com/bead?bomb=believe",
  "http://www.example.com/actor/arch",
  "http://www.example.com/",
  "https://example.com/?balance=bite&bed=bells",
   ]

  def fetch_data_from_url() do
    max_concurrency = System.schedulers_online() * 2
    IO.inspect({:max_concurrency, max_concurrency})
    stream = Task.async_stream(@url, fn req -> Scraper.Fetchurl.finch_call(req) end, max_concurrency: max_concurrency)
    IO.inspect({:resp, stream})
    Enum.map(stream, fn {a, {b, c, d}} -> {b, c, d} end)
  end

  def finch_call(req) do
    IO.puts "came inside the finch call"
    response =
        Finch.build(:get, req)
        |> Finch.request(Scraper.Finch, pool_timeout: 3000, receive_timeout: 3000, request_timeout: 3000)
    # IO.inspect({:response, response})
    case response do
      {:ok, value} ->
        #  IO.inspect({:value, value})

         %{status: status, body: _body} = value
         IO.inspect({:status_code, status})
         if status == 200 do
          {:success, self(), req}
         else
           {:not_found, self(), req}
         end
      {:error, reason} ->
        IO.inspect({:reason, reason})
        %{reason: reason} = reason
         reason = :error
         {reason, self(), req}
    end
  end

end
