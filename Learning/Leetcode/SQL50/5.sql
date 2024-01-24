CREATE TABLE tweets (
    tweet_id INT,
    content VARCHAR(255)
);

INSERT INTO tweets (tweet_id, content) VALUES 
(1, 'Vote for Biden'),
(2, 'Let us make America great again!');

select tweet_id from Tweets  where LENGTH(content) >15