insert into units (symbol, name) values ('kg', 'Kg');
insert into units (symbol, name) values ('pcs', 'Pc(s)');

insert into items (search_key, description, stock_buffer, mpoq, lead_time) values ('DKP', 'Dus Kacang Polong', 1500.00, 4000.00, 56.00);
insert into items (search_key, description, stock_buffer, mpoq, lead_time) values ('DP', 'Dus Polos', 5000.00, 7500.00, 56.00);
insert into items (search_key, description, stock_buffer, mpoq, lead_time) values ('KAPOLGO', 'Kacang Polong Goreng 500 gr', 2000.00, 4000.00, 28.00);
insert into items (search_key, description, stock_buffer, mpoq, lead_time) values ('KAPOLGO-BULK', 'Bulk Kacang Polong Goreng', 1500.00, 3000.00, 7.00);
insert into items (search_key, description, stock_buffer, mpoq, lead_time) values ('KP', 'Kacang polong', 1000.00, 3500.00, 21.00);
insert into items (search_key, description, stock_buffer, mpoq, lead_time) values ('MG', 'Minyak goreng', 100.00, 300.00, 7.00);
insert into items (search_key, description, stock_buffer, mpoq, lead_time) values ('TER', 'Tepung terigu', 500.00, 1500.00, 14.00);
insert into items (search_key, description, stock_buffer, mpoq, lead_time) values ('TK4', 'Tinta K4', 1.00, 3.00, 18.00);

insert into formulas (item_id, sheet_code) values (1, '01');
insert into formula_items(formula_id, item_id, composition) values (1, 2, 1.00000000);
insert into formula_items(formula_id, item_id, composition) values (1, 8, 0.00010000);
insert into formulas (item_id, sheet_code) values (3, '01');
insert into formula_items(formula_id, item_id, composition) values (2, 4, 0.50000000);
insert into formula_items(formula_id, item_id, composition) values (2, 1, 1.00000000);
insert into formulas (item_id, sheet_code) values (4, '01');
insert into formula_items(formula_id, item_id, composition) values (3, 5, 0.62500000);
insert into formula_items(formula_id, item_id, composition) values (3, 7, 0.31250000);
insert into formula_items(formula_id, item_id, composition) values (3, 6, 0.06250000);

insert into bom_nodes(item_id, bom_date, start_stock, in_qty, out_qty) values (3, '2009/08/02', 1000.000000, 0.000000, 1000.000000);
insert into bom_nodes(item_id, bom_date, start_stock, in_qty, out_qty) values (3, '2009/08/09', 0.000000, 0.000000, 1100.000000);
insert into bom_nodes(item_id, bom_date, start_stock, in_qty, out_qty) values (3, '2009/08/16', 0.000000, 0.000000, 1200.000000);
