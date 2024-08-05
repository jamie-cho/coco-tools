import unittest

from coco.b09.procbank import ProcedureBank


class TestProcedureBank(unittest.TestCase):
    def test_includes_given_procedure(self) -> None:
        target = ProcedureBank()
        assert {"foo"} == target._get_procedure_and_dependency_names("foo")

    def test_loads_procedures_from_str(self) -> None:
        target = ProcedureBank()
        procedure = (
            "PROCEDURE foo\nRUN bar()\nPROCEDURE bar\nRUN baz()\n"
            'PROCEDURE baz\nPRINT "HELLO"'
        )
        target.add_from_str(procedure)
        assert {"foo", "bar", "baz"} == target._get_procedure_and_dependency_names(
            "foo"
        )

    def test_loads_procedures_from_resource(self) -> None:
        target = ProcedureBank()
        target.add_from_resource("ecb.b09")
        assert {"ecb_point", "_ecb_get_point_info", "_ecb_text_address"}.issubset(
            target._get_procedure_and_dependency_names("ecb_point")
        )

    def test_can_load_from_resource_and_str(self) -> None:
        target = ProcedureBank()
        target.add_from_resource("ecb.b09")
        procedure = "PROCEDURE foo\nRUN ecb_cls(5)\n\n"
        target.add_from_str(procedure)
        assert {"foo", "ecb_cls", "_ecb_text_address"}.issubset(
            target._get_procedure_and_dependency_names("foo")
        )
        all_procedures = target.get_procedure_and_dependencies("foo")
        assert all_procedures.endswith(procedure.strip())
        assert all_procedures.startswith("procedure _ecb_text_address\n")
        assert "procedure ecb_cls\n" in all_procedures

    def test_substitutes_str_storage_tag_with_default(self) -> None:
        target = ProcedureBank()
        target.add_from_resource("ecb.b09")
        procedure = "PROCEDURE foo\nRUN ecb_string()\n\n"
        target.add_from_str(procedure)
        assert (
            "param str: STRING\nparam strout: STRING"
            in target.get_procedure_and_dependencies("foo")
        )

    def test_substitutes_str_storage_tag(self) -> None:
        target = ProcedureBank(default_str_storage=80)
        target.add_from_resource("ecb.b09")
        procedure = "PROCEDURE foo\nRUN ecb_string()\n\n"
        target.add_from_str(procedure)
        assert (
            "param str: STRING[80]\nparam strout: STRING[80]"
            in target.get_procedure_and_dependencies("foo")
        )
