create table units (
	id integer primary key asc autoincrement,
	symbol char (5),
	metric char (5),
	name char(10)
);

create table items (
	id integer primary key asc autoincrement,
	search_key char (10),
	description char (100),
	unit_id integer,
	logistic_type char (1),
	lead_time integer,
	stock_buffer float,
	mpoq float,
	foreign key (unit_id) references units(id)
);

create table bom_nodes (
	id integer primary key asc autoincrement,
	parent_id integer,
	item_id integer,
	bom_date date,
	start_stock float,
	in_qty float,
	out_qty float,
	flags integer,
	foreign key (item_id) references items(id),
	foreign key (parent_id) references bom_nodes(id)
);

create table sequence_list (
	id integer primary key asc autoincrement,
	previous_id integer,
	next_id integer,
	context char (10),
	seq_group integer,
	data_id integer,
	foreign key (previous_id) references sequence_list(id),
	foreign key (next_id) references sequence_list(id)
);

create table formulas (
	id integer primary key asc autoincrement,
	item_id integer,
	sheet_code char (8),
	foreign key (item_id) references items(id)
);

create table formula_items (
	id integer primary key asc autoincrement,
	formula_id integer,
	item_id integer,
	composition float,
	unit_id integer,
	foreign key (formula_id) references formulas(id),
	foreign key (item_id) references items(id),
	foreign key (unit_id) references units(id)
);

