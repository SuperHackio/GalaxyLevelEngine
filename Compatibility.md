# Compatibility

Below are sections regarding other hacks, or engines.


## Super Mario Galaxy 2 Project Template
The GLE is compatible with the SMG2 Project Template, up to "The August Update".<br/>
There are some things to keep in mind though:
- The GLE files overwrite PT files where applicable.
- The StarChanceExceptTable is no longer needed, as it will not be read (The GLE has it's own implementation of this, see [ScenarioSettings](/ScenarioSettings.md))
- The Project Template's Power Star Color system does not do anything, as the GLE expects star colours to be handled by a different field in ScenarioData.bcsv. See [Power Stars](/PowerStars.md) for more information.



---

> *Note: The GLE developer(s) are not responsible for intentionally making sure that the GLE works with third party additives. This page merely documents what has been tested.*
