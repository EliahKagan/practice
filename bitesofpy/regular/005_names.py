"""Bite 5. Parse a list of names"""

NAMES = ['arnold schwarzenegger', 'alec baldwin', 'bob belderbos',
         'julian sequeira', 'sandra bullock', 'keanu reeves',
         'julbob pybites', 'bob belderbos', 'julian sequeira',
         'al pacino', 'brad pitt', 'matt damon', 'brad pitt']


def _title_case(name):
    return ' '.join(word.capitalize() for word in name.split())


def dedup_and_title_case_names(names):
    """Should return a list of title cased names,
       each name appears only once"""
    return list({_title_case(name) for name in names})


def sort_by_surname_desc(names):
    """Returns names list sorted desc by surname"""
    names = dedup_and_title_case_names(names)
    return sorted(names, key=lambda name: name.split()[-1], reverse=True)


def shortest_first_name(names):
    """Returns the shortest first name (str).
       You can assume there is only one shortest name.
    """
    names = dedup_and_title_case_names(names)
    return min((name.split()[0] for name in names), key=len)
