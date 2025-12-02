.. _async_gaussdb-faq:


Frequently Asked Questions
==========================

Does async_gaussdb support DB-API?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

No.  DB-API is a synchronous API, while async_gaussdb is based
around an asynchronous I/O model.  Thus, full drop-in compatibility
with DB-API is not possible and we decided to design async_gaussdb API
in a way that is better aligned with GaussDB architecture and
terminology.  We will release a synchronous DB-API-compatible version
of async_gaussdb at some point in the future.


Can I use async_gaussdb with SQLAlchemy ORM?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Yes.  SQLAlchemy version 1.4 and later supports the async_gaussdb dialect natively.
Please refer to its documentation for details.  Older SQLAlchemy versions
may be used in tandem with a third-party adapter such as
async_gaussdbsa_ or databases_.


Can I use dot-notation with :class:`async_gaussdb.Record`?  It looks cleaner.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We decided against making :class:`async_gaussdb.Record` a named tuple
because we want to keep the ``Record`` method namespace separate
from the column namespace.  That said, you can provide a custom ``Record``
class that implements dot-notation via the ``record_class`` argument to
:func:`connect() <async_gaussdb.connection.connect>` or any of the Record-returning
methods.

.. code-block:: python

    class MyRecord(async_gaussdb.Record):
        def __getattr__(self, name):
            return self[name]


Why can't I use a :ref:`cursor <async_gaussdb-api-cursor>` outside of a transaction?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Cursors created by a call to
:meth:`Connection.cursor() <async_gaussdb.connection.Connection.cursor>` or
:meth:`PreparedStatement.cursor() \
<async_gaussdb.prepared_stmt.PreparedStatement.cursor>`
cannot be used outside of a transaction.  Any such attempt will result in
``InterfaceError``.
To create a cursor usable outside of a transaction, use the
``DECLARE ... CURSOR WITH HOLD`` SQL statement directly.


.. _async_gaussdb-prepared-stmt-errors:

Why am I getting prepared statement errors?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If you are getting intermittent ``prepared statement "__async_gaussdb_stmt_xx__"
does not exist`` or ``prepared statement “__async_gaussdb_stmt_xx__”
already exists`` errors, you are most likely not connecting to the
GaussDB server directly, but via

* disable automatic use of prepared statements by passing
  ``statement_cache_size=0``
  to :func:`async_gaussdb.connect() <async_gaussdb.connection.connect>` and
  :func:`async_gaussdb.create_pool() <async_gaussdb.pool.create_pool>`
  (and, obviously, avoid the use of
  :meth:`Connection.prepare() <async_gaussdb.connection.Connection.prepare>`);




Why do I get ``GaussDBSyntaxError`` when using ``expression IN $1``?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

``expression IN $1`` is not a valid GaussDB syntax.  To check
a value against a sequence use ``expression = any($1::mytype[])``,
where ``mytype`` is the array element type.

.. _async_gaussdbsa: https://github.com/CanopyTax/async_gaussdbsa
.. _databases: https://github.com/encode/databases
