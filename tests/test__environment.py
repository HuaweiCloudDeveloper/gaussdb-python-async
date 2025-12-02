# Copyright (C) 2016-present the asyncpg authors and contributors
# <see AUTHORS file>
#
# This module is part of asyncpg and is released under
# the Apache 2.0 License: http://www.apache.org/licenses/LICENSE-2.0


import os
import unittest

import async_gaussdb
import async_gaussdb.serverversion

from async_gaussdb import _testbase as tb


class TestEnvironment(tb.ConnectedTestCase):
    @unittest.skipIf(not os.environ.get('GAUSSDBVERSION'),
                     "environ[GAUSSDBVERSION] is not set")
    async def test_environment_server_version(self):
        pgver = os.environ.get('GAUSSDBVERSION')
        env_ver = async_gaussdb.serverversion.split_server_version_string(pgver)
        srv_ver = self.con.get_server_version()

        self.assertEqual(
            env_ver[:2], srv_ver[:2],
            'Expecting GaussDBSQL version {pgver}, got {maj}.{min}.'.format(
                pgver=pgver, maj=srv_ver.major, min=srv_ver.minor)
        )

    @unittest.skipIf(not os.environ.get('ASYNC_GAUSSDB_VERSION'),
                     "environ[ASYNC_GAUSSDB_VERSION] is not set")
    @unittest.skipIf("dev" in async_gaussdb.__version__,
                     "development version with git commit data")
    async def test_environment_ASYNC_GAUSSDB_VERSION(self):
        apgver = os.environ.get('ASYNC_GAUSSDB_VERSION')
        self.assertEqual(
            async_gaussdb.__version__, apgver,
            'Expecting async_gaussdb version {}, got {}.'.format(
                apgver, async_gaussdb.__version__)
        )
