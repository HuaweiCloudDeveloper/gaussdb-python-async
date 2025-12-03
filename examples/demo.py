
import asyncio
import async_gaussdb
# -----------------------------------------------------------------------------
# Database Connection Configuration
# -----------------------------------------------------------------------------
DB_CONFIG = {
    'user': 'root',
    'password': 'password',  # Replace with your actual password
    'database': 'postgres',
    'host': '127.0.0.1',
    'port': 8000
}

async def main():
    print(f"Connecting to GaussDB at {DB_CONFIG['host']}:{DB_CONFIG['port']}...")
    
    # 1. Establish Connection
    # async_gaussdb automatically handles openGauss/GaussDB specific protocols (e.g., SHA256 auth)
    conn = await async_gaussdb.connect(**DB_CONFIG)
    print("✅ Connection established successfully!")

    try:
        # ---------------------------------------------------------------------
        # Step 1: Clean up old data (Drop Table)
        # ---------------------------------------------------------------------
        drop_table_sql = "DROP TABLE IF EXISTS test"
        print(f"\n[Executing] {drop_table_sql}")
        await conn.execute(drop_table_sql)
        print("   -> Table 'test' dropped.")

        # ---------------------------------------------------------------------
        # Step 2: Create new table (Create Table)
        # ---------------------------------------------------------------------
        create_table_sql = (
            "CREATE TABLE test (id serial PRIMARY KEY, num integer, data text)"
        )
        print(f"\n[Executing] {create_table_sql}")
        await conn.execute(create_table_sql)
        print("   -> Table 'test' created.")

        # ---------------------------------------------------------------------
        # Step 3: Insert Data
        # Note: Async drivers for Postgres/GaussDB typically use $1, $2 placeholders
        # instead of %s used in standard synchronous drivers.
        # ---------------------------------------------------------------------
        insert_data_sql = "INSERT INTO test (num, data) VALUES ($1, $2)"
        
        # Preparing sample data
        data_to_insert = [
            (1, 'initial_data'),
            (2, 'data_to_be_updated'), # This row (num=2) will be updated later
            (3, 'other_data')
        ]
        
        print(f"\n[Executing] {insert_data_sql}")
        for num, data in data_to_insert:
            await conn.execute(insert_data_sql, num, data)
            print(f"   -> Inserted row: num={num}, data='{data}'")

        # ---------------------------------------------------------------------
        # Step 4: Update Data
        # ---------------------------------------------------------------------
        update_data_sql = "UPDATE test SET data = 'gaussdb' WHERE num = 2"
        print(f"\n[Executing] {update_data_sql}")
        result = await conn.execute(update_data_sql)
        # 'result' usually contains the command tag (e.g., "UPDATE 1")
        print(f"   -> Update complete: {result}")

        # ---------------------------------------------------------------------
        # Step 5: Select and Verify Data
        # ---------------------------------------------------------------------
        select_sql = "SELECT * FROM test ORDER BY id"
        print(f"\n[Executing] {select_sql}")
        
        # fetch() returns a list of Record objects
        rows = await conn.fetch(select_sql)
        
        print("\n--- Query Results ---")
        for row in rows:
            # Access data by column name or index
            print(f"ID: {row['id']} | Num: {row['num']} | Data: {row['data']}")
            
    except Exception as e:
        print(f"\n❌ An error occurred: {e}")
    finally:
        # ---------------------------------------------------------------------
        # Close Connection
        # ---------------------------------------------------------------------
        print("\nClosing connection...")
        await conn.close()
        print("✅ Connection closed.")

if __name__ == "__main__":
    asyncio.run(main())
