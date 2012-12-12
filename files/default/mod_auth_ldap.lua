
local new_sasl = require "util.sasl".new;
local nodeprep = require "util.encodings".stringprep.nodeprep;
local log = require "util.logger".init("auth_ldap");

local ldap_server = module:get_option("ldap_server") or "localhost";
local ldap_rootdn = module:get_option("ldap_rootdn") or "";
local ldap_password = module:get_option("ldap_password") or "";
local ldap_tls = module:get_option("ldap_tls");
local ldap_base = assert(module:get_option("ldap_base"), "ldap_base is a required option for ldap");
local ldap_scope = module:get_option("ldap_scope") or "onelevel";
local ldap_filter = module:get_option("ldap_filter") or "";

local lualdap = require "lualdap";
local ld = assert(lualdap.open_simple(ldap_server, ldap_rootdn, ldap_password, ldap_tls));
module.unload = function() ld:close(); end

local function ldap_filter_escape(s) return (s:gsub("[\\*\\(\\)\\\\%z]", function(c) return ("\\%02x"):format(c:byte()) end)); end

local function find_userdn(username)
	local iter, err = ld:search {
		base = ldap_base;
		-- we need to set scope here, else ldap-search may fail (silently!!)
		scope = ldap_scope;
		filter = "(&(uid="..ldap_filter_escape(username)..")"..ldap_filter..")";
	}
	if not iter then
	    module:log("error", "LDAP usersearch failed (%s): %s", username, err);
	    return false;
	end
	for dn, attribs in iter do
	   return dn;
	end
	return false;
end

local provider = { name = "ldap" };

function provider.test_password(username, password)
	local userdn = find_userdn(username);
	if not userdn then return false; end
	
	local ldu = lualdap.open_simple(ldap_server, userdn, password, ldap_tls);
	if not ldu then return false; end

	ldu:close();
	return true;
end

function provider.user_exists(username)
	return find_userdn(username);
end

function provider.get_password(username) return nil, "Passwords unavailable for LDAP."; end
function provider.set_password(username, password) return nil, "Passwords unavailable for LDAP."; end
function provider.create_user(username, password) return nil, "Account creation/modification not available with LDAP."; end

function provider.get_sasl_handler()
	local realm = module:get_option("sasl_realm") or module.host;
	local testpass_authentication_profile = {
		plain_test = function(sasl, username, password, realm)
			local prepped_username = nodeprep(username);
			if not prepped_username then
				log("debug", "NODEprep failed on username: %s", username);
				return "", nil;
			end
			return provider.test_password(prepped_username, password), true;
		end
	};
	return new_sasl(realm, testpass_authentication_profile);
end

module:add_item("auth-provider", provider);

