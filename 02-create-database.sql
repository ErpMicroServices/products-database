CREATE TABLE IF NOT EXISTS product_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text UNIQUE NOT NULL CONSTRAINT party_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT product_type_pk PRIMARY key(id));


CREATE TABLE IF NOT EXISTS product(
  id uuid DEFAULT uuid_generate_v4(),
  name text not null constraint product_name_not_empty check(name <>''),
  introduction_date date not null default CURRENT_DATE,
  sales_discontinuation_date date,
  support_discontinuation_date date,
  comment text,
  CONSTRAINT product_pk PRIMARY key(id));

CREATE TABLE IF NOT EXISTS product_category(
  id uuid DEFAULT uuid_generate_v4(),
  description text UNIQUE NOT NULL CONSTRAINT product_category_description_not_empty CHECK (description <> ''),
  constraint product_category_pk primary key(id));

create table if not exists product_category_classifiction(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  primary_flag boolean default false,
  comment text,
  product_id uuid references product(id),
  product_category uuid references product_category(id),
  CONSTRAINT product_category_classifiction_pk PRIMARY key(id)
);

create table if not exists market_interest(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default current_date,
  thru_date date,
  product_category_id uuid not null references product_category(id),
  party_classification_type uuid not null,
  CONSTRAINT market_interest_pk PRIMARY key(id)
);

create table if not exists product_category_rollup(
  id uuid DEFAULT uuid_generate_v4(),
  parent uuid not null references product_category(id),
  child uuid not null references product_category(id),
  CONSTRAINT product_category_rollup_pk PRIMARY key(id)
);
