import logging


def main():
    logging.info("Hello!")


if __name__ == "__main__":
    logging.basicConfig(format='%(asctime)s [%(filename)s:%(lineno)d] %(message)s',
    datefmt='%Y-%m-%dT%H:%M:%S',
    level=logging.DEBUG)
    main()
