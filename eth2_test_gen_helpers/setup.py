from distutils.core import setup

setup(
    name='eth2_test_gen_helpers',
    version='1.0',
    packages=['gen_base'],
    install_requires=['ruamel.yaml', 'eth-utils'],
    license='CC0',
    long_description=open('README.txt').read(),
)
