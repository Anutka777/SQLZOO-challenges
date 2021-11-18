-- Exercise reference: https://sqlzoo.net/wiki/Music_Tutorial
-- Tow tables:
-- * album(asin, title, artist, price, release, label, rank)
-- * track(album, dsk, posn, song)

-- Find the title and artist who recorded the song 'Alison'.
SELECT  title
       ,artist
FROM album
JOIN track
ON (asin = album)
WHERE song = 'Alison';

-- Which artist recorded the song 'Exodus'?
SELECT  artist
FROM album
JOIN track
ON (asin = album)
WHERE song = 'Exodus';

-- Show the song for each track on the album 'Blur'.
SELECT  song
FROM track
JOIN album
ON (album = asin)
WHERE title = 'Blur';

-- For each album show the title and the total number of track.
SELECT  title
       ,COUNT(song) AS 'song number'
FROM album
JOIN track
ON (asin = album)
GROUP BY  title;

-- For each album show the title and the total number of tracks containing
-- the word 'Heart' (albums with no such tracks need not be shown).
SELECT  title
       ,COUNT(song) AS 'number of "heart"-songs'
FROM album
JOIN track
ON (asin = album)
WHERE song LIKE '%Heart%'
GROUP BY  title;

-- A "title track" is where the song is the same as the title.
-- Find the title tracks.
SELECT  song
FROM album
JOIN track
ON (asin = album)
WHERE song = title;

-- An "eponymous" album is one where the title is the same as the artist
-- (for example the album 'Blur' by the band 'Blur'). Show the eponymous albums.
SELECT  title
FROM album
WHERE title = artist;

-- Find the songs that appear on more than 2 albums.
-- Include a count of the number of times each shows up.
SELECT  song
       ,COUNT(DISTINCT title) AS 'number of occurence'
FROM track
JOIN album
ON (album = asin)
GROUP BY  song
HAVING COUNT(DISTINCT title) > 2;
-- *** This solution appears as incorrect. Although I see no difference between
-- my selection and the should-be-answer. Tried long enough, but can't come up
-- with approved solution.***

-- A "good value" album is one where the price per track is less than 50 pence.
-- Find the good value album. Show the title, the price and the number of tracks.
SELECT  title
       ,price
       ,COUNT(song) AS 'number of songs'
FROM album
JOIN track
ON asin = album
GROUP BY  title
         ,price
HAVING price/COUNT(song) < 0.5;

-- List albums so that the album with the most tracks is first. Show the title
-- and the number of tracks. Where two or more albums have the same number
-- of tracks you should order alphabetically.
SELECT  title
       ,COUNT(song) AS 'number of songs'
FROM album
JOIN track
ON (asin = album)
GROUP BY  title
ORDER BY COUNT(song) DESC
         ,title;
