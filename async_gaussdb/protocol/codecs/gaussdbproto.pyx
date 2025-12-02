# Copyright (C) 2016-present the asyncpg authors and contributors
# <see AUTHORS file>
#
# This module is part of asyncpg and is released under
# the Apache 2.0 License: http://www.apache.org/licenses/LICENSE-2.0


cdef init_bits_codecs():
    register_core_codec(BITOID,
                        <encode_func>gaussdbproto.bits_encode,
                        <decode_func>gaussdbproto.bits_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(VARBITOID,
                        <encode_func>gaussdbproto.bits_encode,
                        <decode_func>gaussdbproto.bits_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_bytea_codecs():
    register_core_codec(BYTEAOID,
                        <encode_func>gaussdbproto.bytea_encode,
                        <decode_func>gaussdbproto.bytea_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(CHAROID,
                        <encode_func>gaussdbproto.bytea_encode,
                        <decode_func>gaussdbproto.bytea_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_datetime_codecs():
    register_core_codec(DATEOID,
                        <encode_func>gaussdbproto.date_encode,
                        <decode_func>gaussdbproto.date_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(DATEOID,
                        <encode_func>gaussdbproto.date_encode_tuple,
                        <decode_func>gaussdbproto.date_decode_tuple,
                        GAUSSDB_FORMAT_BINARY,
                        GAUSSDB_XFORMAT_TUPLE)

    register_core_codec(TIMEOID,
                        <encode_func>gaussdbproto.time_encode,
                        <decode_func>gaussdbproto.time_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(TIMEOID,
                        <encode_func>gaussdbproto.time_encode_tuple,
                        <decode_func>gaussdbproto.time_decode_tuple,
                        GAUSSDB_FORMAT_BINARY,
                        GAUSSDB_XFORMAT_TUPLE)

    register_core_codec(TIMETZOID,
                        <encode_func>gaussdbproto.timetz_encode,
                        <decode_func>gaussdbproto.timetz_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(TIMETZOID,
                        <encode_func>gaussdbproto.timetz_encode_tuple,
                        <decode_func>gaussdbproto.timetz_decode_tuple,
                        GAUSSDB_FORMAT_BINARY,
                        GAUSSDB_XFORMAT_TUPLE)

    register_core_codec(TIMESTAMPOID,
                        <encode_func>gaussdbproto.timestamp_encode,
                        <decode_func>gaussdbproto.timestamp_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(TIMESTAMPOID,
                        <encode_func>gaussdbproto.timestamp_encode_tuple,
                        <decode_func>gaussdbproto.timestamp_decode_tuple,
                        GAUSSDB_FORMAT_BINARY,
                        GAUSSDB_XFORMAT_TUPLE)

    register_core_codec(TIMESTAMPTZOID,
                        <encode_func>gaussdbproto.timestamptz_encode,
                        <decode_func>gaussdbproto.timestamptz_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(TIMESTAMPTZOID,
                        <encode_func>gaussdbproto.timestamp_encode_tuple,
                        <decode_func>gaussdbproto.timestamp_decode_tuple,
                        GAUSSDB_FORMAT_BINARY,
                        GAUSSDB_XFORMAT_TUPLE)

    register_core_codec(INTERVALOID,
                        <encode_func>gaussdbproto.interval_encode,
                        <decode_func>gaussdbproto.interval_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(INTERVALOID,
                        <encode_func>gaussdbproto.interval_encode_tuple,
                        <decode_func>gaussdbproto.interval_decode_tuple,
                        GAUSSDB_FORMAT_BINARY,
                        GAUSSDB_XFORMAT_TUPLE)

    # For obsolete abstime/reltime/tinterval, we do not bother to
    # interpret the value, and simply return and pass it as text.
    #
    register_core_codec(ABSTIMEOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    register_core_codec(RELTIMEOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    register_core_codec(TINTERVALOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)


cdef init_float_codecs():
    register_core_codec(FLOAT4OID,
                        <encode_func>gaussdbproto.float4_encode,
                        <decode_func>gaussdbproto.float4_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(FLOAT8OID,
                        <encode_func>gaussdbproto.float8_encode,
                        <decode_func>gaussdbproto.float8_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_geometry_codecs():
    register_core_codec(BOXOID,
                        <encode_func>gaussdbproto.box_encode,
                        <decode_func>gaussdbproto.box_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(LINEOID,
                        <encode_func>gaussdbproto.line_encode,
                        <decode_func>gaussdbproto.line_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(LSEGOID,
                        <encode_func>gaussdbproto.lseg_encode,
                        <decode_func>gaussdbproto.lseg_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(POINTOID,
                        <encode_func>gaussdbproto.point_encode,
                        <decode_func>gaussdbproto.point_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(PATHOID,
                        <encode_func>gaussdbproto.path_encode,
                        <decode_func>gaussdbproto.path_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(POLYGONOID,
                        <encode_func>gaussdbproto.poly_encode,
                        <decode_func>gaussdbproto.poly_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(CIRCLEOID,
                        <encode_func>gaussdbproto.circle_encode,
                        <decode_func>gaussdbproto.circle_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_hstore_codecs():
    register_extra_codec('pg_contrib.hstore',
                         <encode_func>gaussdbproto.hstore_encode,
                         <decode_func>gaussdbproto.hstore_decode,
                         GAUSSDB_FORMAT_BINARY)


cdef init_json_codecs():
    register_core_codec(JSONOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_BINARY)
    register_core_codec(JSONBOID,
                        <encode_func>gaussdbproto.jsonb_encode,
                        <decode_func>gaussdbproto.jsonb_decode,
                        GAUSSDB_FORMAT_BINARY)
    register_core_codec(JSONPATHOID,
                        <encode_func>gaussdbproto.jsonpath_encode,
                        <decode_func>gaussdbproto.jsonpath_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_int_codecs():

    register_core_codec(BOOLOID,
                        <encode_func>gaussdbproto.bool_encode,
                        <decode_func>gaussdbproto.bool_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(INT2OID,
                        <encode_func>gaussdbproto.int2_encode,
                        <decode_func>gaussdbproto.int2_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(INT4OID,
                        <encode_func>gaussdbproto.int4_encode,
                        <decode_func>gaussdbproto.int4_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(INT8OID,
                        <encode_func>gaussdbproto.int8_encode,
                        <decode_func>gaussdbproto.int8_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_pseudo_codecs():
    # Void type is returned by SELECT void_returning_function()
    register_core_codec(VOIDOID,
                        <encode_func>gaussdbproto.void_encode,
                        <decode_func>gaussdbproto.void_decode,
                        GAUSSDB_FORMAT_BINARY)

    # Unknown type, always decoded as text
    register_core_codec(UNKNOWNOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    # OID and friends
    oid_types = [
        OIDOID, CIDOID
    ]

    for oid_type in oid_types:
        register_core_codec(oid_type,
                            <encode_func>gaussdbproto.uint4_encode,
                            <decode_func>gaussdbproto.uint4_decode,
                            GAUSSDB_FORMAT_BINARY)
    
    register_core_codec(XIDOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    # 64-bit OID types
    oid8_types = [
        XID8OID,
    ]

    for oid_type in oid8_types:
        register_core_codec(oid_type,
                            <encode_func>gaussdbproto.uint8_encode,
                            <decode_func>gaussdbproto.uint8_decode,
                            GAUSSDB_FORMAT_BINARY)

    # reg* types -- these are really system catalog OIDs, but
    # allow the catalog object name as an input.  We could just
    # decode these as OIDs, but handling them as text seems more
    # useful.
    #
    reg_types = [
        REGPROCOID, REGPROCEDUREOID, REGOPEROID, REGOPERATOROID,
        REGCLASSOID, REGTYPEOID, REGCONFIGOID, REGDICTIONARYOID,
        REGNAMESPACEOID, REGROLEOID, REFCURSOROID, REGCOLLATIONOID,
    ]

    for reg_type in reg_types:
        register_core_codec(reg_type,
                            <encode_func>gaussdbproto.text_encode,
                            <decode_func>gaussdbproto.text_decode,
                            GAUSSDB_FORMAT_TEXT)

    # cstring type is used by GaussDB' I/O functions
    register_core_codec(CSTRINGOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_BINARY)

    # various system pseudotypes with no I/O
    no_io_types = [
        ANYOID, TRIGGEROID, EVENT_TRIGGEROID, LANGUAGE_HANDLEROID,
        FDW_HANDLEROID, TSM_HANDLEROID, INTERNALOID, OPAQUEOID,
        ANYELEMENTOID, ANYNONARRAYOID, ANYCOMPATIBLEOID,
        ANYCOMPATIBLEARRAYOID, ANYCOMPATIBLENONARRAYOID,
        ANYCOMPATIBLERANGEOID, ANYCOMPATIBLEMULTIRANGEOID,
        ANYRANGEOID, ANYMULTIRANGEOID, ANYARRAYOID,
        GAUSSDB_DDL_COMMANDOID, INDEX_AM_HANDLEROID, TABLE_AM_HANDLEROID,
    ]

    register_core_codec(ANYENUMOID,
                        NULL,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    for no_io_type in no_io_types:
        register_core_codec(no_io_type,
                            NULL,
                            NULL,
                            GAUSSDB_FORMAT_BINARY)

    # ACL specification string
    register_core_codec(ACLITEMOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    # GaussDB' serialized expression tree type
    register_core_codec(GAUSSDB_NODE_TREEOID,
                        NULL,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    # pg_lsn type -- a pointer to a location in the XLOG.
    register_core_codec(GAUSSDB_LSNOID,
                        <encode_func>gaussdbproto.int8_encode,
                        <decode_func>gaussdbproto.int8_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(SMGROID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    # pg_dependencies and pg_ndistinct are special types
    # used in pg_statistic_ext columns.
    register_core_codec(GAUSSDB_DEPENDENCIESOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    register_core_codec(GAUSSDB_NDISTINCTOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    # pg_mcv_list is a special type used in pg_statistic_ext_data
    # system catalog
    register_core_codec(GAUSSDB_MCV_LISTOID,
                        <encode_func>gaussdbproto.bytea_encode,
                        <decode_func>gaussdbproto.bytea_decode,
                        GAUSSDB_FORMAT_BINARY)

    # These two are internal to BRIN index support and are unlikely
    # to be sent, but since I/O functions for these exist, add decoders
    # nonetheless.
    register_core_codec(GAUSSDB_BRIN_BLOOM_SUMMARYOID,
                        NULL,
                        <decode_func>gaussdbproto.bytea_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(GAUSSDB_BRIN_MINMAX_MULTI_SUMMARYOID,
                        NULL,
                        <decode_func>gaussdbproto.bytea_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_text_codecs():
    textoids = [
        NAMEOID,
        BPCHAROID,
        VARCHAROID,
        TEXTOID,
        XMLOID
    ]

    for oid in textoids:
        register_core_codec(oid,
                            <encode_func>gaussdbproto.text_encode,
                            <decode_func>gaussdbproto.text_decode,
                            GAUSSDB_FORMAT_BINARY)

        register_core_codec(oid,
                            <encode_func>gaussdbproto.text_encode,
                            <decode_func>gaussdbproto.text_decode,
                            GAUSSDB_FORMAT_TEXT)


cdef init_tid_codecs():
    register_core_codec(TIDOID,
                        <encode_func>gaussdbproto.tid_encode,
                        <decode_func>gaussdbproto.tid_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_txid_codecs():

    register_core_codec(TXID_SNAPSHOTOID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    register_core_codec(GAUSSDB_SNAPSHOTOID,
                        <encode_func>gaussdbproto.gaussdb_snapshot_encode,
                        <decode_func>gaussdbproto.gaussdb_snapshot_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_tsearch_codecs():
    ts_oids = [
        TSQUERYOID,
        TSVECTOROID,
    ]

    for oid in ts_oids:
        register_core_codec(oid,
                            <encode_func>gaussdbproto.text_encode,
                            <decode_func>gaussdbproto.text_decode,
                            GAUSSDB_FORMAT_TEXT)

    register_core_codec(GTSVECTOROID,
                        NULL,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)


cdef init_uuid_codecs():
    register_core_codec(UUIDOID,
                        <encode_func>gaussdbproto.uuid_encode,
                        <decode_func>gaussdbproto.uuid_decode,
                        GAUSSDB_FORMAT_BINARY)


cdef init_numeric_codecs():
    register_core_codec(NUMERICOID,
                        <encode_func>gaussdbproto.numeric_encode_text,
                        <decode_func>gaussdbproto.numeric_decode_text,
                        GAUSSDB_FORMAT_TEXT)

    register_core_codec(NUMERICOID,
                        <encode_func>gaussdbproto.numeric_encode_binary,
                        <decode_func>gaussdbproto.numeric_decode_binary,
                        GAUSSDB_FORMAT_BINARY)


cdef init_network_codecs():
    register_core_codec(CIDROID,
                        <encode_func>gaussdbproto.cidr_encode,
                        <decode_func>gaussdbproto.cidr_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(INETOID,
                        <encode_func>gaussdbproto.inet_encode,
                        <decode_func>gaussdbproto.inet_decode,
                        GAUSSDB_FORMAT_BINARY)

    register_core_codec(MACADDROID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)

    register_core_codec(MACADDR8OID,
                        <encode_func>gaussdbproto.text_encode,
                        <decode_func>gaussdbproto.text_decode,
                        GAUSSDB_FORMAT_TEXT)


cdef init_monetary_codecs():
    moneyoids = [
        MONEYOID,
    ]

    for oid in moneyoids:
        register_core_codec(oid,
                            <encode_func>gaussdbproto.text_encode,
                            <decode_func>gaussdbproto.text_decode,
                            GAUSSDB_FORMAT_TEXT)


cdef init_all_gaussdbproto_codecs():
    # Builtin types, in lexicographical order.
    init_bits_codecs()
    init_bytea_codecs()
    init_datetime_codecs()
    init_float_codecs()
    init_geometry_codecs()
    init_int_codecs()
    init_json_codecs()
    init_monetary_codecs()
    init_network_codecs()
    init_numeric_codecs()
    init_text_codecs()
    init_tid_codecs()
    init_tsearch_codecs()
    init_txid_codecs()
    init_uuid_codecs()

    # Various pseudotypes and system types
    init_pseudo_codecs()

    # contrib
    init_hstore_codecs()


init_all_gaussdbproto_codecs()
