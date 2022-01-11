DROP DATABASE IF EXISTS extra_03;
CREATE DATABASE extra_03;

\c extra_03


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE numbers (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  number INTEGER NOT NULL
);


INSERT INTO numbers (number) VALUES
(1),
(2),
(-3),
(5),
(-7);

# log(a) + log(b) = log(ab)
# ab = exp(log(a) + log(b))

SELECT abs_value * sgn
FROM (SELECT exp(sum(ln(abs(number)))) as abs_value,
     1 - ((count(CASE WHEN number < 0 THEN 1 END) % 2) * 2) as sgn
     FROM numbers) AS foo;
