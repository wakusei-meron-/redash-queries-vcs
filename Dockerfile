FROM python:3.10.0a7-alpine3.13

RUN pip install click requests
RUN apk update && apk add git

COPY query_export.py /query_export.py
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

