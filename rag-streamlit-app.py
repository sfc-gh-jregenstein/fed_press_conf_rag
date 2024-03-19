## Import libraries
import streamlit as st
from snowflake.snowpark.context import get_active_session

# Get the current credentials
session = get_active_session() 

st.title("Ask about the Fed press conference")
st.write("Built using end-to-end RAG in Snowflake with Cortex functions.")

model = st.selectbox('Select your model:',('mistral-7b', 'llama2-70b-chat','gemma-7b'))

with st.form("prompt", clear_on_submit=False):
    text, btn = st.columns([6, 1])
    prompt = text.text_input("Enter prompt", placeholder="what did the FOMC say about the economy?", label_visibility="collapsed")
    submit = btn.form_submit_button("Submit", type="primary", use_container_width=True)

quest_q = f'''
select snowflake.cortex.complete(
    '{model}', 
    concat( 
        'Answer the question based on the context. Be concise in your answer.','Context: ',
        (
            select chunk from RAG_DEMO.RAG_DEMO_SCHEMA.FED_VECTOR_STORE 
            order by vector_l2_distance(
            snowflake.cortex.embed_text('e5-base-v2', 
            '{prompt}'
            ), chunk_embedding
            ) limit 1
        ),
        'Question: ', 
        '{prompt}',
        'Answer: '
    )
) as response;
'''

if submit and prompt:
    df_query = session.sql(quest_q).to_pandas()
    st.write(df_query['RESPONSE'][0])