.. _async_gaussdb-examples:


async_gaussdb Usage
=============

The interaction with the database normally starts with a call to
:func:`connect() <async_gaussdb.connection.connect>`, which establishes
a new database session and returns a new
:class:`Connection <async_gaussdb.connection.Connection>` instance,
which provides methods to run queries and manage transactions.


.. code-block:: python

    import asyncio
    import async_gaussdb
    import datetime

    async def main():
        # Establish a connection to an existing database named "test"
        # as a "root" user.
        conn = await async_gaussdb.connect('gaussdb://root@localhost/test')
        # Execute a statement to create a new table.
        await conn.execute('''
            CREATE TABLE users(
                id serial PRIMARY KEY,
                name text,
                dob date
            )
        ''')

        # Insert a record into the created table.
        await conn.execute('''
            INSERT INTO users(name, dob) VALUES($1, $2)
        ''', 'Bob', datetime.date(1984, 3, 1))

        # Select a row from the table.
        row = await conn.fetchrow(
            'SELECT * FROM users WHERE name = $1', 'Bob')
        # *row* now contains
        # async_gaussdb.Record(id=1, name='Bob', dob=datetime.date(1984, 3, 1))

        # Close the connection.
        await conn.close()

    asyncio.run(main())


.. note::

   async_gaussdb uses the native GaussDB syntax for query arguments: ``$n``.



Type Conversion
---------------

async_gaussdb automatically converts GaussDB types to the corresponding Python
types and vice versa.  All standard data types are supported out of the box,
including arrays, composite types, range types, enumerations and any
combination of them.  It is possible to supply codecs for non-standard
types or override standard codecs.  See :ref:`async_gaussdb-custom-codecs` for
more information.

The table below shows the correspondence between GaussDB and Python types.

+----------------------+-----------------------------------------------------+
| GaussDB Type      |  Python Type                                        |
+======================+=====================================================+
| ``anyarray``         | :class:`list <python:list>`                         |
+----------------------+-----------------------------------------------------+
| ``anyenum``          | :class:`str <python:str>`                           |
+----------------------+-----------------------------------------------------+
| ``anyrange``         | :class:`async_gaussdb.Range <async_gaussdb.types.Range>`,       |
|                      | :class:`tuple <python:tuple>`                       |
+----------------------+-----------------------------------------------------+
| ``anymultirange``    | ``list[``:class:`async_gaussdb.Range\                     |
|                      | <async_gaussdb.types.Range>` ``]``,                       |
|                      | ``list[``:class:`tuple <python:tuple>` ``]`` [#f1]_ |
+----------------------+-----------------------------------------------------+
| ``record``           | :class:`async_gaussdb.Record`,                            |
|                      | :class:`tuple <python:tuple>`,                      |
|                      | :class:`Mapping <python:collections.abc.Mapping>`   |
+----------------------+-----------------------------------------------------+
| ``bit``, ``varbit``  | :class:`async_gaussdb.BitString <async_gaussdb.types.BitString>`|
+----------------------+-----------------------------------------------------+
| ``bool``             | :class:`bool <python:bool>`                         |
+----------------------+-----------------------------------------------------+
| ``box``              | :class:`async_gaussdb.Box <async_gaussdb.types.Box>`            |
+----------------------+-----------------------------------------------------+
| ``bytea``            | :class:`bytes <python:bytes>`                       |
+----------------------+-----------------------------------------------------+
| ``char``, ``name``,  | :class:`str <python:str>`                           |
| ``varchar``,         |                                                     |
| ``text``,            |                                                     |
| ``xml``              |                                                     |
+----------------------+-----------------------------------------------------+
| ``cidr``             | :class:`ipaddress.IPv4Network\                      |
|                      | <python:ipaddress.IPv4Network>`,                    |
|                      | :class:`ipaddress.IPv6Network\                      |
|                      | <python:ipaddress.IPv6Network>`                     |
+----------------------+-----------------------------------------------------+
| ``inet``             | :class:`ipaddress.IPv4Interface\                    |
|                      | <python:ipaddress.IPv4Interface>`,                  |
|                      | :class:`ipaddress.IPv6Interface\                    |
|                      | <python:ipaddress.IPv6Interface>`,                  |
|                      | :class:`ipaddress.IPv4Address\                      |
|                      | <python:ipaddress.IPv4Address>`,                    |
|                      | :class:`ipaddress.IPv6Address\                      |
|                      | <python:ipaddress.IPv6Address>` [#f2]_              |
+----------------------+-----------------------------------------------------+
| ``macaddr``          | :class:`str <python:str>`                           |
+----------------------+-----------------------------------------------------+
| ``circle``           | :class:`async_gaussdb.Circle <async_gaussdb.types.Circle>`      |
+----------------------+-----------------------------------------------------+
| ``date``             | :class:`datetime.date <python:datetime.date>`       |
+----------------------+-----------------------------------------------------+
| ``time``             | offset-naïve :class:`datetime.time \                |
|                      | <python:datetime.time>`                             |
+----------------------+-----------------------------------------------------+
| ``time with          | offset-aware :class:`datetime.time \                |
| time zone``          | <python:datetime.time>`                             |
+----------------------+-----------------------------------------------------+
| ``timestamp``        | offset-naïve :class:`datetime.datetime \            |
|                      | <python:datetime.datetime>`                         |
+----------------------+-----------------------------------------------------+
| ``timestamp with     | offset-aware :class:`datetime.datetime \            |
| time zone``          | <python:datetime.datetime>`                         |
+----------------------+-----------------------------------------------------+
| ``interval``         | :class:`datetime.timedelta \                        |
|                      | <python:datetime.timedelta>`                        |
+----------------------+-----------------------------------------------------+
| ``float``,           | :class:`float <python:float>` [#f3]_                |
| ``double precision`` |                                                     |
+----------------------+-----------------------------------------------------+
| ``smallint``,        | :class:`int <python:int>`                           |
| ``integer``,         |                                                     |
| ``bigint``           |                                                     |
+----------------------+-----------------------------------------------------+
| ``numeric``          | :class:`Decimal <python:decimal.Decimal>`           |
+----------------------+-----------------------------------------------------+
| ``json``, ``jsonb``  | :class:`str <python:str>`                           |
+----------------------+-----------------------------------------------------+
| ``line``             | :class:`async_gaussdb.Line <async_gaussdb.types.Line>`          |
+----------------------+-----------------------------------------------------+
| ``lseg``             | :class:`async_gaussdb.LineSegment \                       |
|                      | <async_gaussdb.types.LineSegment>`                        |
+----------------------+-----------------------------------------------------+
| ``money``            | :class:`str <python:str>`                           |
+----------------------+-----------------------------------------------------+
| ``path``             | :class:`async_gaussdb.Path <async_gaussdb.types.Path>`          |
+----------------------+-----------------------------------------------------+
| ``point``            | :class:`async_gaussdb.Point <async_gaussdb.types.Point>`        |
+----------------------+-----------------------------------------------------+
| ``polygon``          | :class:`async_gaussdb.Polygon <async_gaussdb.types.Polygon>`    |
+----------------------+-----------------------------------------------------+
| ``uuid``             | :class:`uuid.UUID <python:uuid.UUID>`               |
+----------------------+-----------------------------------------------------+
| ``tid``              | :class:`tuple <python:tuple>`                       |
+----------------------+-----------------------------------------------------+

All other types are encoded and decoded as text by default.

.. [#f1] Since version 0.25.0

.. [#f2] Prior to version 0.20.0, async_gaussdb erroneously treated ``inet`` values
         with prefix as ``IPvXNetwork`` instead of ``IPvXInterface``.

.. [#f3] Inexact single-precision ``float`` values may have a different
         representation when decoded into a Python float.  This is inherent
         to the implementation of limited-precision floating point types.
         If you need the decimal representation to match, cast the expression
         to ``double`` or ``numeric`` in your query.

.. _async_gaussdb-custom-codecs:

Custom Type Conversions
-----------------------

async_gaussdb allows defining custom type conversion functions both for standard
and user-defined types using the :meth:`Connection.set_type_codec() \
<async_gaussdb.connection.Connection.set_type_codec>` and
:meth:`Connection.set_builtin_type_codec() \
<async_gaussdb.connection.Connection.set_builtin_type_codec>` methods.


Example: automatic JSON conversion
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The example below shows how to configure async_gaussdb to encode and decode
JSON values using the :mod:`json <python:json>` module.

.. code-block:: python

    import asyncio
    import async_gaussdb
    import json


    async def main():
        conn = await async_gaussdb.connect()

        try:
            await conn.set_type_codec(
                'json',
                encoder=json.dumps,
                decoder=json.loads,
                schema='pg_catalog'
            )

            data = {'foo': 'bar', 'spam': 1}
            res = await conn.fetchval('SELECT $1::json', data)

        finally:
            await conn.close()

    asyncio.run(main())


Example: complex types
~~~~~~~~~~~~~~~~~~~~~~

The example below shows how to configure async_gaussdb to encode and decode
Python :class:`complex <python:complex>` values to a custom composite
type in GaussDB.

.. code-block:: python

    import asyncio
    import async_gaussdb


    async def main():
        conn = await async_gaussdb.connect()

        try:
            await conn.execute(
                '''
                CREATE TYPE mycomplex AS (
                    r float,
                    i float
                );'''
            )
            await conn.set_type_codec(
                'complex',
                encoder=lambda x: (x.real, x.imag),
                decoder=lambda t: complex(t[0], t[1]),
                format='tuple',
            )

            res = await conn.fetchval('SELECT $1::mycomplex', (1+2j))

        finally:
            await conn.close()

    asyncio.run(main())


Example: automatic conversion of PostGIS types
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The example below shows how to configure async_gaussdb to encode and decode
the PostGIS ``geometry`` type.  It works for any Python object that
conforms to the `geo interface specification`_ and relies on Shapely_,
although any library that supports reading and writing the WKB format
will work.

.. _Shapely: https://github.com/Toblerity/Shapely
.. _geo interface specification: https://gist.github.com/sgillies/2217756

.. code-block:: python

    import asyncio
    import async_gaussdb

    import shapely.geometry
    import shapely.wkb
    from shapely.geometry.base import BaseGeometry


    async def main():
        conn = await async_gaussdb.connect()

        try:
            def encode_geometry(geometry):
                if not hasattr(geometry, '__geo_interface__'):
                    raise TypeError('{g} does not conform to '
                                    'the geo interface'.format(g=geometry))
                shape = shapely.geometry.shape(geometry)
                return shapely.wkb.dumps(shape)

            def decode_geometry(wkb):
                return shapely.wkb.loads(wkb)

            await conn.set_type_codec(
                'geometry',  # also works for 'geography'
                encoder=encode_geometry,
                decoder=decode_geometry,
                format='binary',
            )

            data = shapely.geometry.Point(-73.985661, 40.748447)
            res = await conn.fetchrow(
                '''SELECT 'Empire State Building' AS name,
                          $1::geometry            AS coordinates
                ''',
                data)

            print(res)

        finally:
            await conn.close()

    asyncio.run(main())


Example: decoding numeric columns as floats
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

By default async_gaussdb decodes numeric columns as Python
:class:`Decimal <python:decimal.Decimal>` instances.  The example below
shows how to instruct async_gaussdb to use floats instead.

.. code-block:: python

    import asyncio
    import async_gaussdb


    async def main():
        conn = await async_gaussdb.connect()

        try:
            await conn.set_type_codec(
                'numeric', encoder=str, decoder=float,
                schema='pg_catalog', format='text'
            )

            res = await conn.fetchval("SELECT $1::numeric", 11.123)
            print(res, type(res))

        finally:
            await conn.close()

    asyncio.run(main())


Example: decoding hstore values
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

hstore_ is an extension data type used for storing key/value pairs.
async_gaussdb includes a codec to decode and encode hstore values as ``dict``
objects.  Because ``hstore`` is not a builtin type, the codec must
be registered on a connection using :meth:`Connection.set_builtin_type_codec()
<async_gaussdb.connection.Connection.set_builtin_type_codec>`:

.. code-block:: python

    import async_gaussdb
    import asyncio

    async def run():
        conn = await async_gaussdb.connect()
        # Assuming the hstore extension exists in the public schema.
        await conn.set_builtin_type_codec(
            'hstore', codec_name='pg_contrib.hstore')
        result = await conn.fetchval("SELECT 'a=>1,b=>2,c=>NULL'::hstore")
        assert result == {'a': '1', 'b': '2', 'c': None}

    asyncio.run(run())

.. _hstore


Transactions
------------

To create transactions, the
:meth:`Connection.transaction() <async_gaussdb.connection.Connection>` method
should be used.

The most common way to use transactions is through an ``async with`` statement:

.. code-block:: python

   async with connection.transaction():
       await connection.execute("INSERT INTO mytable VALUES(1, 2, 3)")

.. note::

   When not in an explicit transaction block, any changes to the database
   will be applied immediately.  This is also known as *auto-commit*.

See the :ref:`async_gaussdb-api-transaction` API documentation for more information.


.. _async_gaussdb-connection-pool:

Connection Pools
----------------

For server-type type applications, that handle frequent requests and need
the database connection for a short period time while handling a request,
the use of a connection pool is recommended.  async_gaussdb provides an advanced
pool implementation, which eliminates the need to use an external connection

To create a connection pool, use the
:func:`async_gaussdb.create_pool() <async_gaussdb.pool.create_pool>` function.
The resulting :class:`Pool <async_gaussdb.pool.Pool>` object can then be used
to borrow connections from the pool.

Below is an example of how **async_gaussdb** can be used to implement a simple
Web service that computes the requested power of two.


.. code-block:: python

    import asyncio
    import async_gaussdb
    from aiohttp import web


    async def handle(request):
        """Handle incoming requests."""
        pool = request.app['pool']
        power = int(request.match_info.get('power', 10))

        # Take a connection from the pool.
        async with pool.acquire() as connection:
            # Open a transaction.
            async with connection.transaction():
                # Run the query passing the request argument.
                result = await connection.fetchval('select 2 ^ $1', power)
                return web.Response(
                    text="2 ^ {} is {}".format(power, result))


    async def init_db(app):
        """Initialize a connection pool."""
         app['pool'] = await async_gaussdb.create_pool(database='postgres',
                                                 user='root')
         yield
         await app['pool'].close()

 
    def init_app():
        """Initialize the application server."""
        app = web.Application()
        # Create a database context
        app.cleanup_ctx.append(init_db)
        # Configure service routes
        app.router.add_route('GET', '/{power:\d+}', handle)
        app.router.add_route('GET', '/', handle)
        return app


    app = init_app()
    web.run_app(app)

See :ref:`async_gaussdb-api-pool` API documentation for more information.
