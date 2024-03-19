# fed_press_conf_rag
a demo of how to use cortex for a full RAG architecture on a Federal Reserve Press Conference PDF

# Step 1

    - Go to your Snowflake UI and create a database called "RAG_DEMO". 
    - In that database, create a schema called "RAG_DEMO_SCHEMA". 
    - In that schema, create one internal stage called "UDF" and one internal stage called "FED_PRESS_CONF".
    - Open that stage called "FED_PRESS_CONF", click on +files, and load the FOMC PDF. 

# Step 2

    - Open VSCode or Jupyter or your favorite Python environment and run the code in the Quarto file. That will create our UDF and our UDTF for text extraction and text chunking.

# Step 3

    - Open the sql file called "rag-worksheet.sql" and copy that code into a Snowflake worksheet or create a worksheet and select the 'from sql' option. 
    - We will run that sql code in Snowflake to invoke our UDF and our UDTF and then call the embed_text() function from Cortex to create vector embeddings and add them to our data table.

# Step 4

    - Use the vector_l2-distance() Cortex function to find the chunk embedding closes to our chosen prompt. 
    - The step in this sql code is to test and see how the function works. 

# Step 5

    - Create a streamlit app to let a user ask questions of this earnings transcript via a chat app. 
    - In your Snowflake account, click on "Streamlit" and then +Streamlit App. 
    - Next choose the RAG_DEMO database and RAG_DEMO_SCHEMA as the location for the streamlit app. 
    - Use the rag-streamlit-app.py code in this github repo to create the RAG streamlit app.
