-- написать какой-нибудь запрос с устранением полных дублей через row_number

SELECT row_number() OVER (PARTITION BY genre
                          ORDER BY genre), genre
FROM songs;
