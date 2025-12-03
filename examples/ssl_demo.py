
import asyncio
import async_gaussdb
import os

# -----------------------------------------------------------------------------
# Scenario: Configuring SSL using DSN (Data Source Name)
# This method is simpler than creating a raw ssl.SSLContext and mimics
# standard PostgreSQL connection strings.
# -----------------------------------------------------------------------------

# Path to your server's CA certificate.
# If 'sslrootcert' is not provided, the driver defaults to looking at:
# ~/.postgresql/root.crt (Linux/Mac) or %APPDATA%\postgresql\root.crt (Windows)
CERTS = os.path.join(os.path.dirname(__file__), '../tests/certs')
SSL_CERT_FILE = os.path.join(CERTS, 'server.cert.pem')
async def main():
    # -------------------------------------------------------------------------
    # Constructing the DSN Connection String
    # Format: gaussdb://user:password@host:port/database?param=value
    # 
    # Key Parameters:
    # 1. sslmode=verify-ca  -> Verifies the server's certificate signature.
    #                          (Use 'verify-full' to also verify the hostname)
    # 2. sslrootcert=...    -> Explicitly tells the driver where the CA file is.
    # -------------------------------------------------------------------------
    
    dsn = (
        f"gaussdb://testuser:Test%40123@127.0.0.1:5432/postgres"
        f"?sslmode=verify-ca&sslrootcert={SSL_CERT_FILE}"
    )

    print(f"Connecting via DSN: ...sslmode=verify-ca&sslrootcert={os.path.basename(SSL_CERT_FILE)}")

    try:
        # Connect to the database
        # We do not need to pass a 'ssl=' context object here because the DSN 
        # contains all the necessary configuration.
        conn = await async_gaussdb.connect(dsn)
        
        print("SSL Connection Successful (via sslmode)!")
        print(f"   Encryption Status: {conn._protocol.is_ssl}")

        # ---------------------------------------------------------------------
        # Core Tasks (Drop -> Create -> Insert -> Update -> Select)
        # ---------------------------------------------------------------------
        
        # 1. Clean up old data
        drop_table_sql = "DROP TABLE IF EXISTS test"
        print(f"\n[Executing] {drop_table_sql}")
        await conn.execute(drop_table_sql)
        
        # 2. Create new table
        create_table_sql = (
            "CREATE TABLE test (id serial PRIMARY KEY, num integer, data text)"
        )
        print(f"\n[Executing] {create_table_sql}")
        await conn.execute(create_table_sql)
        
        # 3. Insert Data (Using $1, $2 placeholders for async driver)
        insert_data_sql = "INSERT INTO test (num, data) VALUES ($1, $2)"
        print(f"\n[Executing] {insert_data_sql}")
        
        await conn.execute(insert_data_sql, 1, "sslmode_demo")
        await conn.execute(insert_data_sql, 2, "wait_for_update") # num=2 will be updated
        print("   -> Inserted 2 rows.")
        
        # 4. Update Data
        update_data_sql = "UPDATE test SET data = 'gaussdb' WHERE num = 2"
        print(f"\n[Executing] {update_data_sql}")
        await conn.execute(update_data_sql)
        print("   -> Update complete.")
        
        # 5. Select and Verify
        select_sql = "SELECT * FROM test ORDER BY id"
        print(f"\n[Executing] {select_sql}")
        rows = await conn.fetch(select_sql)
        
        print("\n--- Query Results ---")
        for row in rows:
            print(f"ID: {row['id']} | Num: {row['num']} | Data: {row['data']}")

    except Exception as e:
        print(f"\nERROR Connection or Execution Failed: {e}")
        print("   Hint: Check if 'server.crt' exists and if the server supports SSL.")
        
    finally:
        if 'conn' in locals():
            print("\nClosing connection...")
            await conn.close()
            print("✅ Connection closed.")

if __name__ == "__main__":
    # Check for file existence just for this tutorial to be helpful
    if not os.path.exists(SSL_CERT_FILE):
        print(f"⚠️ WARNING: The certificate file was not found at: {SSL_CERT_FILE}")
        print("   (The code will attempt to connect, but will likely fail)")
    
    asyncio.run(main())
