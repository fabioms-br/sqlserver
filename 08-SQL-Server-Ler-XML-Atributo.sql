
DECLARE @XMLCodigo XML =
'<?xml version="1.0" encoding="UTF-8"?>
<resultset>
    <det nItem="1">
        <prod>
          <cProd>24323</cProd>
		</prod>
	</det>	
</resultset>';
SELECT c.value('@nItem', 'CHAR(1)') AS nItem
FROM @XMLCodigo.nodes('/resultset/det') AS t(c);