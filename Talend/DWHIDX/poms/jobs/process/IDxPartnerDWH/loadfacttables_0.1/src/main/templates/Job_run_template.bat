%~d0
cd %~dp0
java -Dtalend.component.manager.m2.repository="%cd%/../lib" -Xms256M -Xmx1024M -Dfile.encoding=UTF-8 -cp .;../lib/routines.jar;../lib/log4j-slf4j-impl-2.13.2.jar;../lib/log4j-api-2.13.2.jar;../lib/log4j-core-2.13.2.jar;../lib/log4j-1.2-api-2.13.2.jar;../lib/jtds-1.3.1-patch-20190523.jar;../lib/SparseBitSet-1.2.jar;../lib/commons-math3-3.6.1.jar;../lib/commons-collections4-4.4.jar;../lib/jboss-marshalling-2.0.12.Final.jar;../lib/commons-compress-1.21.jar;../lib/talend_file_enhanced-1.1.jar;../lib/commons-codec-1.14.jar;../lib/curvesapi-1.06.jar;../lib/poi-4.1.2-20200903124306_modified_talend.jar;../lib/dom4j-2.1.3.jar;../lib/poi-ooxml-4.1.2-20200903124306_modified_talend.jar;../lib/talend_DB_mssqlUtil-1.4.jar;../lib/slf4j-api-1.7.29.jar;../lib/poi-ooxml-schemas-4.1.2-20200903124306_modified_talend.jar;../lib/xmlbeans-3.1.0.jar;../lib/poi-scratchpad-4.1.2-20200903124306_modified_talend.jar;../lib/talendcsv-1.0.0.jar;../lib/crypto-utils-0.31.12.jar;loadfacttables_0_1.jar; dwhidx.loadfacttables_0_1.LoadFactTables %*