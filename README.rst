async_gaussdb -- A fast GaussDB/openGauss Database Client Library for Python/asyncio
=====================================================================================

**async_gaussdb** is a database interface library designed specifically for
GaussDB and openGauss databases with Python/asyncio. This fork of async_gaussdb is
optimized for GaussDB/openGauss compatibility, including native SHA256
authentication support and enhanced features for enterprise database environments.

async_gaussdb requires Python 3.8 or later and is specifically designed for
GaussDB and openGauss databases. It includes compatibility fixes and
optimizations for openGauss-specific features and enterprise database requirements.

**Key Features for GaussDB/openGauss:**
* Native SHA256 authentication support
* Optimized for openGauss protocol compatibility
* Enhanced error handling for enterprise database features
* Support for GaussDB-specific data types and functions
* Comprehensive test suite adapted for openGauss


Features
--------

async_gaussdb implements the GaussDB/openGauss server protocol natively and
exposes its features directly, optimized for enterprise database environments:

* **SHA256 authentication** - Native support for GaussDB/openGauss authentication
* **prepared statements** - Optimized for openGauss query execution
* **scrollable cursors** - Full cursor support for large result sets
* **partial iteration** on query results - Memory-efficient data processing
* automatic encoding and decoding of composite types, arrays,
  and any combination of those
* straightforward support for custom data types
* **openGauss compatibility** - Comprehensive test suite and error handling
* **Enterprise features** - Optimized for production GaussDB environments

 
Installation
------------

async_gaussdb is available on PyPI. When not using GSSAPI/SSPI authentication it
has no dependencies. Use pip to install::

    $ pip install async-gaussdb

If you need GSSAPI/SSPI authentication, use::

    $ pip install 'async-gaussdb[gssauth]'


Basic Usage
-----------

.. code-block:: python

    import asyncio
    import async_gaussdb

    async def run():
        # Connect to GaussDB/openGauss
        conn = await async_gaussdb.connect(
            user='omm',
            password='your_password',
            database='postgres',
            host='127.0.0.1',
            port=5432
        )
        
        # Execute queries with full GaussDB support
        values = await conn.fetch(
            'SELECT * FROM mytable WHERE id = $1',
            10,
        )
        await conn.close()

    asyncio.run(run())


GaussDB/openGauss Specific Features 
-----------------------------------

This library includes enhanced support for GaussDB and openGauss databases:

.. code-block:: python

    import asyncio
    import async_gaussdb

    async def run():
        # Connect with SHA256 authentication (GaussDB/openGauss specific)
        conn = await async_gaussdb.connect(
            user='omm',
            password='your_password',
            database='postgres',
            host='127.0.0.1',
            port=5432
        )
        
        # Use GaussDB-specific features
        # The library automatically handles openGauss protocol differences
        values = await conn.fetch(
            'SELECT * FROM mytable WHERE id = $1',
            10,
        )
        await conn.close()

    asyncio.run(run())

async-gaussdb is developed and distributed under the Apache 2.0 license 
by MagicStack Inc. and the HuaweiCloudDeveloper team.
