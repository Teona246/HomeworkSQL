CREATE TABLE "order"(
"id" BIGINT GENERATED ALWAYS AS IDENTITY,
"customer_id" BIGINT,
"product_id" BIGINT,
"category" VARCHAR(200)
);