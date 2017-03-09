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
  manufactured_by uuid,
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

create table if not exists good_identification_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT good_identification_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT good_identification_type_id_value_pk PRIMARY key(id)
);

create table if not exists good_identification_id_value(
  id uuid DEFAULT uuid_generate_v4(),
  value text not null CONSTRAINT good_identification_id_value_not_empty CHECK (value <> ''),
  good_id uuid not null references product(id),
  good_identification_type_id uuid not null references good_identification_type(id),
  CONSTRAINT good_identification_id_value_pk PRIMARY key(id)
);

create table if not exists product_feature_category(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT product_feature_category_description_not_empty CHECK (description <> ''),
  CONSTRAINT product_feature_category_pk PRIMARY key(id)
);

create table if not exists unit_of_measure(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT unit_of_measure_description_not_empty CHECK (description <> ''),
  abbreviation text,
  CONSTRAINT unit_of_measure_pk PRIMARY key(id)
);

create table if not exists unit_of_measure_converstion(
  id uuid DEFAULT uuid_generate_v4(),
  convert_from uuid not null references unit_of_measure(id),
  convert_to uuid not null references unit_of_measure(id),
  conversion_factor double precision not null,
  CONSTRAINT unit_of_measure_converstion_pk PRIMARY key(id)
);

create table if not exists product_feature_category(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT product_feature_category_description_not_empty CHECK (description <> ''),
  number_specified bigint,
  product_feature_category_id uuid not null references product_feature_category(id),
  unit_of_measure_id uuid references unit_of_measure(id),
  CONSTRAINT product_feature_category_pk PRIMARY key(id)
);

create table if not exists product_feature(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT product_feature_category_description_not_empty CHECK (description <> ''),
  product_feature_category_id uuid not null references product_feature_category(id),
  unit_of_measure_id uuid references unit_of_measure(id),
  CONSTRAINT product_feature_pk PRIMARY key(id)
);

create table if not exists product_feature_applicability_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT product_feature_category_description_not_empty CHECK (description <> ''),
  CONSTRAINT product_feature_applicability_type_pk PRIMARY key(id)
);

create table if not exists product_feature_applicability(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default CURRENT_DATE,
  thru_date date,
  product_feature_applicability_type_id uuid not null references product_feature_applicability_type(id),
  product_feature_id uuid not null references product_feature(id),
  product_id uuid not null references product(id),
  CONSTRAINT product_feature_applicabilitye_pk PRIMARY key(id)
);

create table if not exists product_feature_interaction_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT product_feature_interaction_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT product_feature_interaction_type_pk PRIMARY key(id)
);

create table if not exists product_feature_interaction(
  id uuid DEFAULT uuid_generate_v4(),
  between_this uuid not null references product_feature(id),
  and_this uuid not null references product_feature(id),
  context_of uuid not null references product(id),
  product_feature_interaction_type uuid not null references product_feature_interaction_type(id),
  CONSTRAINT product_feature_interaction_pk PRIMARY key(id)
);

create table if not exists reorder_guideline(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default CURRENT_DATE,
  thru_date date,
  reorder_quantity int default 1,
  reorder_level int default 1,
  based_on_geographic_boundary uuid,
  based_on_facility uuid,
  based_on_internal_organization uuid,
  CONSTRAINT reorder_guideline_pk PRIMARY key(id)
);

create table if not exists preference_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT preference_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT preference_type_pk PRIMARY key(id)
);

create table if not exists rating_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT rating_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT rating_type_type_pk PRIMARY key(id)
);

create table if not exists supplier_product(
  id uuid DEFAULT uuid_generate_v4(),
  available_from_date date not null default CURRENT_DATE,
  available_thru_date date,
  standard_lead_time interval not null,
  comment text,
  product_id uuid not null references product(id),
  organization_id uuid not null,
  preference_type_id uuid not null references preference_type(id),
  rating_type_id uuid not null references rating_type(id),
  CONSTRAINT supplier_product_pk PRIMARY key(id)
)
