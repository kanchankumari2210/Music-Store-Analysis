//Q1: Who is the senior most employee based on the job title?//

select * from employee 
order by levels desc
limit 10

//Q2: Which countries have the most invoices //

select * from invoice;

select count(*) as c, billing_country
from invoice 
group by billing_country
order by c desc

//Q3: What are top 3 values of total invoices//

select total from invoice
order by total desc
limit 3

//Q:4 Which city has the best customerss? we would like to throw a promotional music festival 
in the city we made the most money. write a query that returns one city that has the highest sum of invoices totals. 
Return both city name & sum of all invoices totals//

select sum(total) as invoice_total, billing_city  
from invoice
group by billing_city 
order by invoice_total desc

// Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the money.//

select * from customer
select c.customer_id, c.first_name, c.last_name,sum(i.total) as total
from customer c
join invoice i on c.customer_id = i.customer_id
group by c.customer_id
order by total desc
limit 1

// Q6: Write query to return the email, first_name, last_name, & Genre of all Rock Music Listner.
Return your list ordered alphabetically by emial starting with A//
 
select distinct email, first_name, last_name
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
where track_id in(
	select track_id from track  
	join genre  on track.genre_id = genre.genre_id
	 where genre.name Like 'Rock'
)
 order by email;

-- Q7: lets's invite the artists who have written the most rock music in our dataset
-- Write a query that returns the Artist name and total tract count of the top 10 rock bands.
 
 select artist.artist_id, artist.name, count(artist.artist_id) as number_of_songs
 from track 
 join album on album.album_id = track.album_id
 join artist on artist.artist_id = album.album_id
 join genre on genre.genre_id = track.genre_id
 where genre.name like 'Rock'
 group by artist.artist_id
 order by number_of_songs desc
 limit 10;

--Q8: Return all the tracks names that have a song length longer than the average song lenght. Return the Name and Milliseconds 
-- for each Track. Order by the song length with the longest song listed first.

select name, milliseconds 
from track
where milliseconds >(
        select avg(milliseconds) as avg_track_length
        from track)
order by milliseconds desc;

-- Q9: Find how much amount spent by each customer on artists? Write a query to return customer name,
-- artist name and totsl spent

With best_selling_artist As(
      Select artist.artist_id As artist_id, artist.name As artist_name, 
	  Sum(invoice_line.unit_price*invoice_line.quantity) As total_sales
      from invoice_line
       join track on track.track_id = invoice_line.track_id       
       join album on album.album_id = track.album_id
	   join artist on artist.artist_id = album.artist_id
	   group by 1
	  order by 3 desc
      limit 1
)
select c.customer_id, c.first_name, c.last_name, bsa.artist_name, sum(il.unit_price*il.quantity)
As amount_spent from invoice i
join customer c on c.customer_id = i.customer_id
join invoice_line il on il.invoice_id = i.invoice_id
join track t on t.track_id = il.track_id
join album alb on alb.album_id = t.album_id
join best_selling_artist bsa on
bsa.artist_id = alb.artist_id
group by 1,2,3,4
order  by 5 Desc;








