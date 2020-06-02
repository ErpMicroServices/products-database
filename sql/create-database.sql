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
  party_classification_type_id uuid not null,
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

create table if not exists good_identification(
  id uuid DEFAULT uuid_generate_v4(),
  value text not null CONSTRAINT good_identification_not_empty CHECK (value <> ''),
  good_id uuid not null references product(id),
  good_identification_type_id uuid not null references good_identification_type(id),
  CONSTRAINT good_identification_pk PRIMARY key(id)
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
  conversion_factor numeric(17,2) not null,
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
);

create table if not exists inventory_item_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT inventory_item_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT inventory_item_type_pk PRIMARY key(id)
);

create table if not exists inventory_item_status_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT inventory_item_status_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT inventory_item_status_type_type_pk PRIMARY key(id)
);

create table if not exists lot(
  id uuid DEFAULT uuid_generate_v4(),
  creation_date date not null default CURRENT_DATE,
  quantity bigint default 1,
  expiration_date date,
  CONSTRAINT lot_pk PRIMARY key(id)
);

create table if not exists container_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT container_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT container_type_pk PRIMARY key(id)
);

create table if not exists container(
  id uuid DEFAULT uuid_generate_v4(),
  description text ,
  container_type_id uuid not null references container_type(id),
  CONSTRAINT container_pk PRIMARY key(id)
);

create table if not exists inventory_item (
  id uuid DEFAULT uuid_generate_v4(),
  serial_num text,
  quantity_on_hand bigint,
  good_id uuid not null,
  inventory_item_status_type_id uuid,
  lot_id uuid,
  container_id uuid,
  facility_id uuid,
  CONSTRAINT inventory_item_pk PRIMARY key(id)
);

create table if not exists reason(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT reason_description_not_empty CHECK (description <> ''),
  CONSTRAINT reason_pk PRIMARY key(id)
);

create table if not exists inventory_item_variance(
  id uuid DEFAULT uuid_generate_v4(),
  comment text,
  quantity bigint default 1,
  physical_inventory_date date not null default CURRENT_DATE,
  reason_id uuid not null references reason(id),
  inventory_item_id uuid not null references inventory_item(id),
  CONSTRAINT inventory_item_variance_pk PRIMARY key(id)
);

create table if not exists price_component_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT price_component_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT price_component_type_pk PRIMARY key(id)
);

create table if not exists quantity_break(
  id uuid DEFAULT uuid_generate_v4(),
  from_quantity bigint,
  thru_quantity bigint,
  CONSTRAINT quantity_break_pk PRIMARY key(id)
);

create table if not exists order_value(
  id uuid DEFAULT uuid_generate_v4(),
  from_amount numeric(17,2),
  thru_amount numeric(17,2),
  CONSTRAINT order_value_pk PRIMARY key(id)
);

create table if not exists sale_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT sale_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT sale_type_pk PRIMARY key(id)
);

create table if not exists price_component(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default CURRENT_DATE,
  thru_date date,
  price numeric(17,2),
  percent numeric(3,2),
  comment text,
  geographic_boundary_id uuid,
  party_type uuid,
  product_category_id uuid references product_category,
  quantity_break_id uuid references quantity_break(id),
  order_value_id uuid references order_value(id),
  sale_type uuid references sale_type(id),
  unit_of_measure_id uuid references unit_of_measure,
  currency_id uuid references unit_of_measure(id),
  party_id uuid,
  product_feature_id uuid references product_feature,
  product_id uuid references product(id),
  CONSTRAINT price_component_pk PRIMARY key(id)
);

create table if not exists estimated_product_cost_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT estimated_product_cost_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT estimated_product_cost_type_pk PRIMARY key(id)
);

create table if not exists cost_component_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT cost_component_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT cost_component_type_pk PRIMARY key(id)
);
create table if not exists estimated_product_cost(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default CURRENT_DATE,
  thru_date date,
  cost numeric(17,2) not null,
  estimated_product_cost_type_id uuid not null references estimated_product_cost_type(id),
  product_id uuid not null references product(id),
  product_feature_id uuid references product_feature(id),
  geographic_boundary_id uuid,
  organization_id uuid,
  CONSTRAINT estimated_product_cost_pk PRIMARY key(id)
);

create table if not exists product_association_type(
  id uuid DEFAULT uuid_generate_v4(),
  description text not null CONSTRAINT product_association_type_description_not_empty CHECK (description <> ''),
  CONSTRAINT product_association_type_pk PRIMARY key(id)
);

create table if not exists product_association(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default CURRENT_DATE,
  thru_date date,
  reason text,
  quantity_used bigint,
  instruction text,
  quantity bigint,
  product_association_type_id uuid not null references product_association_type(id),
  from_product uuid not null references product(id),
  to_product uuid not null references product(id),
  CONSTRAINT product_association_pk PRIMARY key(id)
);

create table if not exists product_component(
  id uuid DEFAULT uuid_generate_v4(),
  from_date date not null default CURRENT_DATE,
  thru_date date,
  quantity_used bigint default 1,
  instruction text,
  comment text,
  in_product uuid not null references product(id),
  for_product uuid not null references product(id),
  CONSTRAINT product_component_pk PRIMARY key(id)
);
