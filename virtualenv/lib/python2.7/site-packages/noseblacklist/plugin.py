import logging
import os
import re

from nose.plugins import Plugin

LOG = logging.getLogger('nose.plugins.blacklist')


class BlacklistPlugin(Plugin):
    name = 'blacklist'

    def options(self, parser, env=os.environ):
        super(BlacklistPlugin, self).options(parser, env)

        parser.add_option(
            "--blacklist",
            action="append",
            dest="blacklist_strs",
            default=[],
            help="A match string to exclude test cases. This can be a python "
                 "regex.",
        )

        parser.add_option(
            "--blacklist-file",
            action="append",
            dest="blacklist_files",
            default=[],
            help="A file with a list of regexes specifying tests to exclude. "
                 "These regexes will be use in addition to any specified via "
                 "the --blacklist option. There should be one item per line. "
                 "Lines starting with '#' will be ignored.",
        )

    def configure(self, options, conf):
        super(BlacklistPlugin, self).configure(options, conf)
        if not self.enabled:
            return

        self.blacklist_regexes = [
            re.compile(x) for x in options.blacklist_strs
        ]
        self._add_blacklists_from_files(options.blacklist_files)

    def wantMethod(self, method):
        test_name = "{0}.{1}.{2}".format(
            method.im_class.__module__,
            method.im_class.__name__,
            method.__name__,
        )
        if self._is_blacklisted(test_name):
            return False

    def wantFunction(self, function):
        test_name = "{0}.{1}".format(
            function.__module__,
            function.__name__,
        )
        if self._is_blacklisted(test_name):
            return False

    def _is_blacklisted(self, name):
        return any(re.search(x, name) for x in self.blacklist_regexes)

    def _add_blacklists_from_files(self, files):
        for filename in files:
            lines = self._read_file(filename)
            self.blacklist_regexes.extend([re.compile(x) for x in lines])

    def _read_file(self, filename):
        """Return the lines from the given file, ignoring lines that start with
        comments"""
        result = []
        with open(filename, 'r') as f:
            lines = f.read().split('\n')
            for line in lines:
                nocomment = line.strip().split('#')[0].strip()
                if nocomment:
                    result.append(nocomment)
        return result
