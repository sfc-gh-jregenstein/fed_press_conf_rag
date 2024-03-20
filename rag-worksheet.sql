-- invoke UDF to extract text from PDF
CREATE OR REPLACE TABLE FED_RAW_TEXT AS
SELECT
    relative_path
    , file_url
    , snowpark_pdf(build_scoped_file_url(@fed_press_conf, relative_path)) as raw_text
from directory(@fed_press_conf);

SELECT *
FROM FED_RAW_TEXT;

-- Create the chunked version of the table
CREATE OR REPLACE TABLE FED_CHUNK_TEXT AS
SELECT
        relative_path,
        func.*
    FROM FED_RAW_TEXT AS raw,
         TABLE(chunk_text(raw_text)) as func;

SELECT *
FROM FED_CHUNK_TEXT;

--Convert your chunks to embeddings
CREATE OR REPLACE TABLE FED_VECTOR_STORE AS
SELECT
RELATIVE_PATH as PRESS_CONF,
CHUNK AS CHUNK,
snowflake.ml.embed_text('e5-base-v2', chunk) as chunk_embedding
FROM FED_CHUNK_TEXT;

SELECT *
FROM FED_VECTOR_STORE;

SELECT PRESS_CONF, CHUNK, CHUNK_EMBEDDING from RAG_DEMO.RAG_DEMO_SCHEMA.FED_VECTOR_STORE
            ORDER BY VECTOR_L2_DISTANCE(
            snowflake.ml.embed_text('e5-base-v2', 
            'have rates peaked?'
            ), CHUNK_EMBEDDING
            ) limit 1
        ;
