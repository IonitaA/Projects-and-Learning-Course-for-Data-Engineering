import psycopg2
import json
import os
import multiprocessing
import time
import sys

def connection_database():
    try:
        conn = psycopg2.connect("host=localhost dbname=myfirstdb user=postgres password=postgres")
        cur = conn.cursor()

        conn.set_session(autocommit=True)
        return conn, cur
    except psycopg2.Error as e:
        print("Error connecting to the database:")
        print(e)
        return None, None
    
def setup_database(cur):
    try:
        cur.execute("drop TABLE IF EXISTS versions ")
    except psycopg2.Error as e:
        print("Error: Issue deleting table")
        print(e)

    try:
        cur.execute("drop TABLE IF EXISTS authors_parsed ")
    except psycopg2.Error as e:
        print("Error: Issue deleting table")
        print(e)

    try:
        cur.execute("drop TABLE IF EXISTS articles ")
    except psycopg2.Error as e:
        print("Error: Issue deleting table")
        print(e)

    try:
        cur.execute("""
        CREATE TABLE IF NOT EXISTS articles (
            id VARCHAR(255) UNIQUE PRIMARY KEY,
            submitter VARCHAR(255),
            authors TEXT,
            title TEXT,
            comments TEXT,
            journal_ref VARCHAR(255),
            doi VARCHAR(255),
            report_no VARCHAR(255),
            categories TEXT,
            license VARCHAR(255),
            abstract TEXT,
            update_date DATE
        );
        """)
    except psycopg2.Error as e:
        print("Error: Issue creating table")
        print(e)

    try:
        cur.execute("""
        CREATE TABLE IF NOT EXISTS versions (
            article_id VARCHAR(255),
            version VARCHAR(255),
            created TIMESTAMP,
            FOREIGN KEY (article_id) REFERENCES articles(id)
        );
        """)
    except psycopg2.Error as e:
        print("Error: Issue creating table")
        print(e)

    try:
        cur.execute("""
        CREATE TABLE IF NOT EXISTS authors_parsed (
            article_id VARCHAR(255),
            name VARCHAR(255),
            surname VARCHAR(255),
            affiliation VARCHAR(255),
            FOREIGN KEY (article_id) REFERENCES articles(id)
        );
        """)
    except psycopg2.Error as e:
        print("Error: Issue creating table")
        print(e)


def process_file(filename, cur):
    file_name = os.path.basename(filename)

    data_articles = []
    data_versions = []
    data_authors = []


    total = 0
    rate = 50
    try:
        with open(filename,'r') as file:
            for i, line in enumerate(file):
                article = json.loads(line)
                
                # Add the data to the corresponding lists
                data_articles.append((article['id'], article['submitter'], article['authors'], article['title'] ,article['comments'] , (article['journal-ref'][:255] if article['journal-ref'] else None),
                (article['doi'][:255] if article['doi'] else None), (article['report-no'][:255] if article['report-no'] else None),article['categories'],
                (article['license'][:255] if article['license'] else None), article['abstract'],article['update_date']))
                
                data_versions.extend([(article['id'], version['version'], version['created']) for version in article['versions']])
                
                data_authors.extend([(article['id'], author[0], author[1], author[2]) for author in article['authors_parsed']])
                
                # At every "rate" line, insert the data into the database and clear the lists
                if (i+1) % rate == 0:
                    total += rate
                    cur.executemany("""
                        INSERT INTO articles (id, submitter, authors, title, comments, journal_ref, doi, report_no, categories, license, abstract, update_date)
                        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        """, data_articles)
                    
                    cur.executemany("""
                        INSERT INTO versions (article_id, version, created)
                        VALUES (%s, %s, %s)
                        """, data_versions)
                    
                    cur.executemany("""
                        INSERT INTO authors_parsed (article_id, name, surname, affiliation)
                        VALUES (%s, %s, %s, %s)
                        """, data_authors)
                    
                    print(f"Pana acum s au adaugat primele {total} linii de date din tabelul {file_name} ")
                    
                    # Empty the lists
                    data_articles = []
                    data_versions = []
                    data_authors = []


            
            # Insert any remaining data into the database.
            if data_articles:
                cur.executemany("""
                    INSERT INTO articles (id, submitter, authors, title, comments, journal_ref, doi, report_no, categories, license, abstract, update_date)
                    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                    """, data_articles)
                
            if data_versions:
                cur.executemany("""
                    INSERT INTO versions (article_id, version, created)
                    VALUES (%s, %s, %s)
                    """, data_versions)
                
            if data_authors:
                cur.executemany("""
                    INSERT INTO authors_parsed (article_id, name, surname, affiliation)
                    VALUES (%s, %s, %s, %s)
                    """, data_authors)
            
            print(f"s au adaugat toate datele ptr tabelul {file_name}")
    except Exception as e:
        print(f"Error processing file {filename}: {e}")

def process_file_with_new_connection(filename):
    conn, cur = connection_database()
    if conn and cur:
        process_file(filename, cur)
        cur.close()
        conn.close()


def split_json_file(filename, lines_per_file):

    directory_name = os.path.dirname(filename)
    file_name =  os.path.splitext(os.path.basename(filename))[0]

    line_count = 0
    file_count = 0
    
    source_file = open(filename, 'r')
    current_out_file = open(f'{directory_name}/{file_name}_{file_count}.json', 'w')

    for line in source_file:
        if line_count >= lines_per_file:
            current_out_file.close()
            file_count += 1
            current_out_file = open(f'{directory_name}/{file_name}_{file_count}.json', 'w')
            line_count = 0

        current_out_file.write(json.dumps(line) + '\n')
        line_count += 1

    current_out_file.close()
    source_file.close()

def main():
    start_time = time.time()

    dir_path = "Data"
    dir_split = "Data/Splited_Data"

    conn, cur = connection_database()

    setup_database(cur)

    cur.close()
    conn.close()

    
    if not os.path.exists(dir_split):
        os.makedirs(dir_split)
        file_name = ""
        # demension for split
        dimmension = 100
        for filename in os.listdir(dir_path):
            if filename.endswith('.json'):
                file_name = filename
                break
            else:
                print("Not found JSON.")
                sys.exit()
        split_json_file(file_name,dimmension)

    files = [os.path.join(dir_split, filename) for filename in os.listdir(dir_split) if filename.endswith('.json')]

    pool = multiprocessing.Pool(3)
    pool.map(process_file_with_new_connection, files)

    end_time = time.time()
    execution_time = end_time - start_time
    print(f"The program ran: {execution_time} seconds")

if __name__ == "__main__":

    main()
