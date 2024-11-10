select 
	track,
	-- stream,
	most_played_on,
	coalesce(sum(case when most_played_on = 'Youtube' then stream end),0) as stream_on_youtube
from spotify
group by track

select 
* from spotify

select 
count(*)
from spotify

select count(distinct artist) from spotify

select count(distinct album) from spotify

select distinct album_type from spotify

select duration_min from  spotify

select min(duration_min) from spotify
select max(duration_min) from spotify

delete from spotify
where duration_min = 0

select * from spotify
where duration_min = 0
-- -----------------------------------
-- Data Analysis Easy Category
-- -----------------------------------
-- Que 1.Retrieve the names of all tracks that have more than 1 billion streams.
select 
	track,
	stream 
from spotify
where stream >1000000000

-- Que2. List all albums along with their respective artists.

select 
	distinct album,
	artist
from spotify

-- Que 3 Get the total number of comments for tracks where licensed = TRUE.

select
	track,
	sum(comments) as total_comments
from spotify
where licensed  = 'true'
group by track

-- Que 4 Find all tracks that belong to the album type single.

select
*
from spotify
where album_type = 'single'

-- Que 5 Count the total number of tracks by each artist.
select * from spotify
select
	artist,
	count(track) as no_of_songs
from spotify
group by artist
order by count(track) desc

-- -----------------------------------
-- Data Analysis Medium Level
-- -----------------------------------

-- Que 1 Calculate the average danceability of tracks in each album.
select
	album,
	avg(danceability) as avg_dancebility
from spotify
group by album

-- Que 2 Find the top 5 tracks with the highest energy values.
select 
	track,
	max(energy) as max_energy
from spotify
group by track
order by max(energy) desc
limit 5

-- Que 3 List all tracks along with their views and likes where official_video = TRUE.
select
	track,
	sum(views) as total_views,
	sum(likes) as total_likes
from spotify
where official_video = 'true'
group by track
order by sum(views) desc
limit 5

-- Que 4 For each album, calculate the total views of all associated tracks.
select
	album,
	track,
	sum(views) as total_views
from spotify
group by album,track
order by sum(views)desc
limit 6

-- Que 5 Retrieve the track names that have been streamed on Spotify more than YouTube.
with cte as
(
select
	track,
	coalesce(sum((case when most_played_on = 'Spotify' Then stream end)),0) as stream_on_spotify,
	coalesce(sum((case when most_played_on = 'Youtube' Then stream end)),0) as stream_on_youtube
from spotify
group by track
)
select 
*
from cte
where stream_on_spotify > stream_on_youtube and stream_on_youtube  != 0

-- -----------------------------------
-- Data Analysis Advanced Level 
-- -----------------------------------
-- Que 1 Find the top 3 most-viewed tracks for each artist using window functions.
with cte as 
(
select
	artist,
	track,
	sum(views) as total_views,
	dense_rank() over (partition by artist order by sum(views)desc) as rk
from spotify
group by artist,track
-- order by 1,3 desc
-- limit 3
)
select 
*
from cte
where rk<=3

-- Que 2 Write a query to find tracks where the liveness score is above the average.
-- USING SUB QUERY --
select
	album,
	track,
	liveness
from spotify
where liveness >(select avg(liveness) as avg_liveness from spotify)

-- Que 3 calculate the difference between the highest and lowest energy values for tracks in each album.
with cte as
(
select
	album,
	max(energy) as max_energy,
	min(energy) as min_energy
from spotify
group by album
)
select 
album,
max_energy,
min_energy,
max_energy - min_energy as energy_diff
from cte
order by energy_diff desc

-- Que 5 Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
select 
	track,
	likes,
	views,
	sum(likes) over (order by sum(views) desc rows between 2 preceding and current row) as rk
from spotify
group by track,likes,views
order by views desc
-- ///// Using Avg Likes -- ////////
SELECT 
    track,
    views,
    likes,
    AVG(likes) OVER (ORDER BY views DESC ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS moving_avg_likes
FROM 
    spotify
GROUP BY 
    track, views, likes
ORDER BY views DESC;
	-- 


